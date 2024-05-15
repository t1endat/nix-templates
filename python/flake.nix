{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
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
                  packages = with pkgs; [
                    black # formatter 
                    isort # formatter
                    nodePackages.pyright #lsp for python
                    # dockerfile-language-server-nodejs # lsp for docker
                  ];
                  
                  # https://devenv.sh/reference/options/
                  languages.python = {
                    enable = true;
                    poetry = {
                      enable = true;
                      install = {
                        enable = true;
                      };
                      activate.enable = true;
                    };
                  };
                  
                  # https://devenv.sh/pre-commit-hooks/
                  pre-commit.hooks = {
                    # autoflake.enable = true;
                    # black.enable = true;
                    # check-python.enable = true;
                    # flake8.enable = true;                   
                    # flynt.enable = true;
                    # isort.enable = true;
                    # mypy.enable = true;
                    # poetry-check.enable = true;
                    # poetry-lock.enable = true;
                    # pylint.enable = true;
                    # pyright.enable = true;
                    # python-debug-statements.enable = true;
                    # pyupgrade.enable = true;
                    # ruff.enable = true;
                  };
                  
                }
              ];
            };
          });
    };
}
