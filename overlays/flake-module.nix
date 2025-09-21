{
  lib,
  inputs,
  ...
}:
{
  flake.overlays = rec {
    blast = import ./blast.nix;
    unstable = import ./unstable-packages.nix { inherit inputs; };
    default = lib.composeManyExtensions [
      blast
      unstable
    ];
  };
}
