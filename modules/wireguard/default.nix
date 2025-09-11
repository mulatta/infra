{
  config,
  lib,
  pkgs,
  ...
}:
let
  wireguardPort = 51820;
  cfg = config.networking.sbee.currentHost;
  all = config.networking.sbee.hosts;
  others = lib.filterAttrs (name: _: name != config.networking.hostName) all;
  wireguardPeers = lib.mapAttrsToList (name: host: {
    PublicKey = builtins.readFile ./keys/${name};
    Endpoint = "${host.ipv4}:${builtins.toString wireguardPort}";
    AllowedIPs = [ "${host.wg0}/32" ];
    PersistentKeepalive = 25;
  }) others;
in
{
  systemd.network.netdevs."wg0" = {
    netdevConfig = {
      Name = "wg0";
      Kind = "wireguard";
    };
    wireguardConfig = {
      PrivateKeyFile = config.sops.secrets.wg-key.path;
      ListenPort = wireguardPort;
    };

    inherit wireguardPeers;
  };

  systemd.network.networks."wg0" = {
    matchConfig.Name = "wg0";
    address = [ "${cfg.wg0}/24" ];
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    trustedInterfaces = [ "wg0" ];
  };

  sops.secrets.wg-key = {
    mode = "0400";
    owner = "systemd-network";
    group = "systemd-network";
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
