{
  imports = [
    ../modules/hardware/vultr-vms.nix
    ../modules/disko/ext4-root.nix
  ];

  disko.rootDisk = "/dev/vda";
  networking.hostName = "turing";

  system.stateVersion = "25.05";
}
