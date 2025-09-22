_: {
  services.teleport = {
    enable = true;
    settings = {
      teleport = {
        nodename = "";
        auth_servers = [];
        log.severity = "DEBUG";
        auth_token = "";
      };

      ssh_service = {
        enable = true;
        labels = {};
      };

      proxy_service.enabled = true;
      auth_service.enabled = true;
    };
  };

  sops.secrets.teleport_auth_token = {
    sopsFile = ./secrets.yaml;
  };
}
