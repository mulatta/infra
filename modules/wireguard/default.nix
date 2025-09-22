{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.networking.sbee.currentHost;
  all = config.networking.sbee.hosts;
  others = lib.filterAttrs (name: _: name != config.networking.hostName) all;

  mkWireguardNetwork = interface: port: let
    mkPeers =
      lib.mapAttrsToList (hostName: host: {
        PublicKey = builtins.readFile (./keys + "/${hostName}_${interface}");
        Endpoint = "${host.ipv4}:${builtins.toString port}";
        AllowedIPs = ["${host.${interface}}/32"];
        PersistentKeepalive = 25;
      })
      others;
  in {
    netdev = {
      netdevConfig = {
        Name = interface;
        Kind = "wireguard";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."${interface}-key".path;
        ListenPort = port;
      };
      wireguardPeers = mkPeers;
    };

    network = {
      matchConfig.Name = interface;
      address = ["${cfg.${interface}}/24"];
    };

    firewallPort = port;
    secretName = "${interface}-key";
  };

  networks = {
    wg-mgnt = mkWireguardNetwork "wg-mgnt" 51820;
    wg-serv = mkWireguardNetwork "wg-serv" 51821;
  };
in {
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
    })
    networks
  );

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
