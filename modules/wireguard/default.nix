{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.networking.sbee.currentHost;
  all = config.networking.sbee.hosts;
  others = lib.filterAttrs (name: _: name != config.networking.hostName) all;

  mkWireguardNetwork =
    {
      name,
      port,
      ipField,
      subnet ? "/24",
    }:
    let
      mkPeers = lib.mapAttrsToList (hostName: host: {
        PublicKey = builtins.readFile (./keys + "/${hostName}_${name}");
        Endpoint = "${host.ipv4}:${builtins.toString port}";
        AllowedIPs = [ "${host.${ipField}}/32" ];
        PersistentKeepalive = 25;
      }) others;
    in
    {
      netdev = {
        netdevConfig = {
          Name = name;
          Kind = "wireguard";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets."${name}-key".path;
          ListenPort = port;
        };
        wireguardPeers = mkPeers;
      };

      network = {
        matchConfig.Name = name;
        address = [ "${cfg.${ipField}}${subnet}" ];
      };

      firewallPort = port;
      secretName = "${name}-key";
    };

  networks = {
    wg-mgnt = mkWireguardNetwork {
      name = "wg-mgnt";
      port = 51820;
      ipField = "wg-mgnt";
    };

    wg-serv = mkWireguardNetwork {
      name = "wg-serv";
      port = 51821;
      ipField = "wg-serv";
    };
  };
in
{
  systemd.network.netdevs = lib.mapAttrs (_: net: net.netdev) networks;
  systemd.network.networks = lib.mapAttrs (_: net: net.network) networks;

  networking.firewall = {
    allowedUDPPorts = lib.mapAttrsToList (_: net: net.firewallPort) networks;
    trustedInterfaces = lib.mapAttrsToList (name: _: name) networks;
  };

  sops.secrets = lib.listToAttrs (
    lib.mapAttrsToList (_: net: {
      name = net.secretName;
      value = {
        mode = "0400";
        owner = "systemd-network";
        group = "systemd-network";
      };
    }) networks
  );

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
