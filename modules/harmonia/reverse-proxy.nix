{config, ...}: {
  imports = [../acme];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;

    virtualHosts."cache.sjanglab.org" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        extraConfig = ''
          proxy_pass http://${config.networking.sbee.hosts.tau.wg-serv}:5000;
          proxy_set_header Host $host;
          proxy_http_version 1.1;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
      };
    };
  };

  security.acme.certs."cache.sjanglab.org" = {
    dnsProvider = "cloudflare";
    environmentFile = config.sops.secrets.cloudflare-credentials.path;
    webroot = null;
  };
}
