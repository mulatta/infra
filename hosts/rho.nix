{
  imports = [
    ../modules/hardware/asrock-deskmini-x600.nix
    ../modules/disko/xfs-root.nix
    ../modules/disko/xfs-storage.nix
    ../modules/wake-on-lan.nix
    ../modules/minio
  ];

  disko.rootDisk = "/dev/disk/by-id/nvme-eui.00000000000000006479a79cdac0038a";
  disko.xfsStorage.disks.storage1 = "/dev/disk/by-id/ata-WDC_WD20SPZX-00UA7T0_WD-WXB2A153H96N";
  disko.xfsStorage.disks.storage2 = "/dev/disk/by-id/ata-WDC_WD20SPZX-00UA7T0_WD-WXB2A153H6KD";

  networking.hostName = "rho";

  system.stateVersion = "25.05";
}
