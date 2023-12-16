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
          black # formatter 
          isort # formatter
          nodePackages.pyright #lsp for emacs
          (python311.withPackages(ps: with ps; [
            pip # for install extensions
            ipython
            jupyterlab
            jedi-language-server

            #additional packages
            numpy
            polars 
            scikit-learn
            ipywidgets # require by plotly 
            plotly
            tensorflow
          ]))
        ];
        # shellHook = "jupyter-lab";
      };
    }
  );
}
