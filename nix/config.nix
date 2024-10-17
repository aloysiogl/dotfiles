{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        #programs
        bat
        neovim
        ncdu
        vim
        zoxide
        lazygit
        nvimpager
        zotero
        blender
        #python
        pipx
        poetry
        ruff
        ruff-lsp
        #git
        delta
        #node
        nodejs_22
        #nvim
        tree-sitter
      ];
    };
  };
}

