{config, ...}: let
  # We use tau as binary cache server
  cacheAddress = config.networking.sbee.hosts.tau.wg-serv;
in {
  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.harmonia-private-key.path];
    settings = {
      bind = "${cacheAddress}:8080";
      workers = 4;
      max_connection_rate = 256;
      priority = 30;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [];
    interfaces.wg-serv.allowedTCPPorts = [8080];
  };

  networking.firewall.extraCommands = ''
    iptables -I INPUT -p tcp --dport 8080 ! -s 10.200.0.0/24 ! -j DROP
  '';

  sops.secrets.harmonia-private-key = {
    sopsFile = ./secrets.yaml;
    owner = "harmonia";
    group = "harmonia";
    mode = "0400";
  };
}
