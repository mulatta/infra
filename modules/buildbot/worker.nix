# Buildbot Worker (deployed on psi)
{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.networking.sbee) hosts;
in {
  imports = [inputs.buildbot-nix.nixosModules.buildbot-worker];

  services.buildbot-nix.worker = {
    enable = true;
    workerPasswordFile = config.sops.secrets.buildbot-worker-password.path;
    masterUrl = "tcp:host=${hosts.psi.wg-serv}:port=9989";
  };

  # Add attic-client to worker PATH for postBuildSteps
  systemd.services.buildbot-worker.path = [pkgs.attic-client];

  sops.secrets.buildbot-worker-password = {
    sopsFile = ./secrets.yaml;
    owner = "buildbot-worker";
    group = "buildbot-worker";
  };
}
