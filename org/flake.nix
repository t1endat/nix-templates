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
            sqlite # required by roam
            typst # write paper
            typst-lsp
            typst-fmt
            nodePackages.mermaid-cli # diagram using mermaid

            # run rust in org
            rustup # you should install stable version by command: rustup default stable
            rust-script

            # run python in org
            python311
          ];
        };
      });
    };
}
