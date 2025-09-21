{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    google-cloud-sdk # for blast update_blastdb.pl runtime
    nextflow
    blast
    zellij
    minio-client
    rsync
    rclone
  ];
}
