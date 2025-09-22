{
  config,
  lib,
  ...
}: let
  cfg = config.networking.sbee.currentHost;
  hostname = config.networking.hostName;
in {
  config = {
    # use networkd
    networking.dhcpcd.enable = false;
    systemd.network.enable = true;

    # add an entry to /etc/hosts for each host
    networking.extraHosts = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: host: ''
        ${host.ipv4} ${name}
      '')
      config.networking.sbee.hosts
    );

    boot.initrd.systemd.network.networks."10-ethernet" = config.systemd.network.networks."10-ethernet";

    # we only manage our in-house instances
    # provisioned instances are managed by provider
    systemd.network.networks."10-ethernet" =
      {
        matchConfig.MACAddress = cfg.mac;
        routes = [{Gateway = "${cfg.gateway}";}];
      }
      // lib.optionalAttrs (hostname == "psi" || hostname == "rho" || hostname == "tau") {
        address = ["${cfg.ipv4}/24"];
        dns = [
          "117.16.191.6"
          "168.126.63.1"
        ];
      }
      // lib.optionalAttrs (hostname == "eta") {
        address = ["${cfg.ipv4}/23"];
        dns = [
          "8.8.8.8"
          "1.1.1.1"
        ];
      };
  };
}
