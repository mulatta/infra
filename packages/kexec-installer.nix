{
  self,
  pkgs,
  ...
}: let
  commonModules = {
    imports = [
      self.inputs.nixos-images.nixosModules.kexec-installer
      self.inputs.nixos-images.nixosModules.noninteractive
      {
        system.kexec-installer.name = "nixos-kexec-installer-noninteractive";
        services.openssh.ports = [10022];
      }
    ];
  };
in
  (pkgs.nixos commonModules).config.system.build.kexecInstallerTarball
