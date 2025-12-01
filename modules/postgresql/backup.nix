{
  config,
  pkgs,
  ...
}: let
  rhoWgMgnt = config.networking.sbee.hosts.rho.wg-mgnt;
in {
  systemd.tmpfiles.rules = [
    "d /var/backup/postgresql-from-rho 0750 root root -"
  ];

  systemd.services.pg-dump-sync = {
    description = "Rsync PostgreSQL SQL dumps from rho";
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = ''
      ${pkgs.rsync}/bin/rsync -avz \
        ${rhoWgMgnt}:/var/backup/postgresql/ \
        /var/backup/postgresql-from-rho/
    '';
  };

  systemd.timers.pg-dump-sync = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
  };
}
