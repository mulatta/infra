{config, ...}: let
  proxy = upstream: ''
    proxy_pass http://@${upstream}/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_http_version 1.1;
    proxy_buffering off;

    limit_req zone=cache_limit burst=20 nodelay;
  '';
in {
  imports = [../acme];
  services.nginx = {
    commonHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=cache_limit:10m rate=10r/s;
    '';
    upstreams = {
      "@cache".extraConfig = "server 10.200.0.4:8080;";
    };

    virtualHosts."cache.sjanglab.org" = {
      forceSSL = true;
      enableACME = true;
      extraConfig = ''
        add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains; preload' always;
      '';
      locations."/".extraConfig = proxy "cache";
    };
  };

  security.acme.certs."cache.sjanglab.org" = {
    dnsProvider = "cloudflare";
    environmentFile = config.sops.secrets.cloudflare-credentials.path;
    webroot = null;
  };
}
