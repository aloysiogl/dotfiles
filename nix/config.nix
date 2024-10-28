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
        # blender (does not work in ubuntu)
        libreoffice
        inkscape
        vlc
        cmake
        neofetch
        htop
        ollama
        google-cloud-sdk
        terraform
        gh # github cli
        ffmpeg
        findutils
        opencv
        # audio vide editing
        audacity
        imagemagick


        boost
        #python
        pipx
        poetry
        virtualenv
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

