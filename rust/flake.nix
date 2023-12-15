{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, fenix, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            fenixpkgs = fenix.packages.${system};
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;

              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [ 
                    lldb_17
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
