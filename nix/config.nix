{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        # Programs
        pkgs.bat
        pkgs.neovim
        pkgs.vim
        pkgs.zoxide
        pkgs.lazygit
        pkgs.nvimpager
        pkgs.zotero

        # Git
        pkgs.delta

        # Node
        pkgs.nodejs_22

        # Nvim
        tree-sitter
      ];
    };
  };
}
