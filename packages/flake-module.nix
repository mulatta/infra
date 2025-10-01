{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages = lib.optionalAttrs pkgs.stdenv.isLinux {
      installer = pkgs.callPackage ./image-installer {inherit pkgs self;};
      kexec = pkgs.callPackage ./kexec-installer.nix {inherit pkgs self;};
    };
  };
}
