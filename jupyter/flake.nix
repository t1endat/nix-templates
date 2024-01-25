{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixfmt # formatter for nix
          
          black # formatter 
          isort # formatter
          nodePackages.pyright #lsp for emacs
          (python311.withPackages(ps: with ps; [
            virtualenv
            ipython
            jupyter-core
            jedi-language-server # lsp
            loguru # logging
            pytest # testing
            debugpy # debugger

            # additional packages
            numpy
            polars
            scikit-learn
            ipywidgets # require by plotly
            plotly
            torch
            torchinfo
            pytest
          ]))
        ];
        # shellHook = "jupyter-lab";
      };
    }
  );
}
