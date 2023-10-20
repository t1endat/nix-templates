{ inputs, ... }:

{
  pre-commit.hooks = {
    # lint shell scripts
    shellcheck.enable = true;
    # execute example shell from Markdown files
    mdsh.enable = true;
    # format Python code
    black.enable = true;
  };
}
