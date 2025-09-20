{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ipmitool
    nvme-cli
    pciutils
    python3
    git
    lsof
    ripgrep
    htop
    wget
    openssl
    jq
    rsync
    rclone
    lftp
    minio-client
    zellij
    nextflow
    blast
    google-cloud-sdk # for blast update_blastdb.pl runtime
    btop
    curl
  ];
}
