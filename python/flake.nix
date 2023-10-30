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
                    python311
                    poetry #package manager
                    black #formatter 
                    ruff #better linting
                    nodePackages.pyright #lsp
                    ] ++
                      (with pkgs.python311Packages; [
                        pip 
                        nose2 #testing
                        cython_3 
                      ]);
                  pre-commit.hooks = {
                    # lint shell scripts
                    shellcheck.enable = true;
                    # execute example shell from Markdown files
                    mdsh.enable = true;
                    # format Python code
                    black.enable = true;
                  };
                }
              ];
            };
          });
    };
}
