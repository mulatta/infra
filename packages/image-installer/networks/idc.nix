{
  systemd.network.networks = {
    "10-ethernet".extraConfig = ''
      [Match]
      Type = ether
      [Network]
      Address = 117.16.251.37/24
      Gateway = 117.16.251.254
      DNS = 117.16.191.6
      DNS = 168.126.63.1
    '';
  };
}
