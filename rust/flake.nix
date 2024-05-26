{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
                  packages = [ 
                    # gui support for wayland
                    # expat
                    # fontconfig
                    # freetype
                    # freetype.dev
                    # libGL
                    # libxkbcommon
                    # pkg-config
                    # xorg.libX11
                    # xorg.libXcursor
                    # xorg.libXi
                    # xorg.libXrandr
                    # wayland
                  ];
                  
                  languages.rust = {
                    enable = true;
                    channel = "stable";
                    components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];
                    # targets = ["wasm32-wasi"]
                    # targets = ["wasm32-unknown-unknown"]
                    # targets = ["thumbv7m-none-eabi"]
                    # components = [ "llvm-tools-preview" ]
                  };
                  
                  # https://devenv.sh/pre-commit-hooks/
                  pre-commit.hooks = {
                    cargo-check.enable = true;
                    rustfmt.enable = true;
                    clippy.enable = true;
                  };
                }
              ];
            };
          });
    };
}
