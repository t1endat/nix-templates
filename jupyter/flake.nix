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
          (python3.withPackages(ps: with ps; [
            pip #for install extensions
            ipython
            jupyterlab
            jedi-language-server
            black 
            isort

            #additional packages
            numpy
            pandas
            seaborn
            matplotlib
            scikit-learn
            plotly # better viz
            ipywidgets # requirement plotly
          ]))
        ];
        # shellHook = "jupyter-lab";
      };
    }
  );
}
