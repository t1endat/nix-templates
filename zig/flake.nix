{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;

              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [
                    zls
                  ];

                  # https://devenv.sh/languages/
                  languages.zig = {
                    enable = true;
                  };

                  # https://devenv.sh/pre-commit-hooks/
                  pre-commit.hooks = {
                    # lint shell scripts
                    # shellcheck.enable = true;
                  };
                }
              ];
            };
          });
    };
}
