{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem = {
    treefmt = {
      # Used to find the project root
      projectRootFile = ".git/config";

      programs = {
        deadnix.enable = true;
        hclfmt.enable = true;
        keep-sorted.enable = true;
        nixfmt.enable = true;
        ruff-check.enable = true;
        ruff-format.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        statix.enable = true;
        terraform.enable = true;
        typos.enable = true;
        yamlfmt.enable = true;
      };

      settings.formatter = {
        deadnix.excludes = [
          "modules/users/researchers.nix"
          "modules/users/students.nix"
        ];
        statix.excludes = [
          "modules/users/researchers.nix"
          "modules/users/students.nix"
        ];
      };

      settings.global.excludes = [
        "*/secrets.yaml"
        "*/secrets.yml"
        "*.lock"
        ".gitignore"
      ];
    };
  };
}
