{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.srvos.nixosModules.hardware-vultr-vm
    ../modules/hardware/vultr-vms.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  networking.hostName = "eta";
  system.stateVersion = "25.05";
}
