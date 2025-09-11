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
  ];
}
