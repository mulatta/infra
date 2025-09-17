{ config, ... }:
let
  inherit (config.networking.sbee) hosts;
in
{
  services.minio = {
    enable = true;

    listenAddress = ":9000";
    consoleAddress = ":9001";

    dataDir = [
      "http://${hosts.rho.wg-mgnt}:9000/storage/storage1"
      "http://${hosts.rho.wg-mgnt}:9000/storage/storage2"
      "http://${hosts.tau.wg-mgnt}:9000/storage/storage1"
      "http://${hosts.tau.wg-mgnt}:9000/storage/storage2"
    ];

    rootCredentialsFile = config.sops.templates."minio-credentials".path;
    browser = true;
  };

  systemd.tmpfiles.rules = [
    "d /storage/storage1 0755 minio minio -"
    "d /storage/storage2 0755 minio minio -"
  ];

  networking.firewall = {
    interfaces.wg-mgnt.allowedTCPPorts = [
      9000
      9001
    ];
    interfaces.wg-serv.allowedTCPPorts = [ 9000 ];
  };

  sops.secrets.minio_root_user = {
    sopsFile = ./secrets.yaml;
    owner = "minio";
    group = "minio";
    mode = "0400";
  };

  sops.secrets.minio_root_password = {
    sopsFile = ./secrets.yaml;
    owner = "minio";
    group = "minio";
    mode = "0400";
  };

  sops.templates."minio-credentials" = {
    content = ''
      MINIO_ROOT_USER=${config.sops.placeholder.minio_root_user}
      MINIO_ROOT_PASSWORD=${config.sops.placeholder.minio_root_password}
    '';
    owner = "minio";
    group = "minio";
    mode = "0400";
  };
}
