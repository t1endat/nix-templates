{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
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
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

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
                    gdb # debugger
                  ];

                  # https://devenv.sh/languages/
                  languages.rust = {
                    enable = true;
                    # https://devenv.sh/reference/options/#languagesrustchannel
                    components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];
                    toolchain.rustc = fenixpkgs.fromToolchainFile { dir = ./.; };
                  };

                  # https://devenv.sh/pre-commit-hooks/
                  pre-commit.hooks = {
                    rustfmt.enable = true;
                    clippy.enable = true;
                  };
                  
                }
              ];
            };
          });
    };
}
