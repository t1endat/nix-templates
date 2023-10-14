{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [ 
          python311 
          ] ++
            (with pkgs.python311Packages; [ 
              pip 
              nose2
              black
              pyflakes
              isort
              cython_3
            ]) 
            ++
            (with pkgs.emacsPackages; [
              poetry
              pyenv-mode
              lsp-pyright
            ]) 
            ;
        };
      });
    };
}
