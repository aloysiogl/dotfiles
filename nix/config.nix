{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        pkgs.bat
        pkgs.neovim
        pkgs.vim
        pkgs.zoxide
        pkgs.lazygit

        # Nvim
        tree-sitter
      ];
    };
  };
}