# https://github.com/nix-community/infra/blob/d886971901070f0d1f5265cef08582051c856e7d/modules/shared/nix-daemon.nix
{
  pkgs,
  ...
}: let
  asGB = size: toString (size * 1024 * 1024 * 1024);
in {
  nix = {
    gc.automatic = pkgs.lib.mkDefault true;
    gc.dates = "";
    gc.options = pkgs.lib.mkDefault "--delete-older-than 14d";

    settings = {
      trusted-substituters = ["http://10.200.0.4:8080"];

      substituters = [
        "http://10.200.0.4:8080"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.sjanglab.org-1:qnmAmr3qctcLiatkrtYX3OpvFKP4Z9whK8pLtSdCgPw="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      post-build-hook = pkgs.writeShellScript "uploadCache" ''
        set -eu
        set -f
        export IFS=' '
        ${pkgs.nix}/bin/nix copy \
        --to "http://10.200.0.4:8080" \
        $OUT_PATHS || true
      '';

      system-features = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];

      # auto-free the /nix/store
      min-free = asGB 10;
      max-free = asGB 50;

      # Hard-link duplicated files
      auto-optimise-store = true;
    };
  };
}
