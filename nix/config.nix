{
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        # text editing
        vim
        neovim

        # program launcher
        albert 

        # utilities
        bat
        delta
        ncdu

        # backups
        rclone
        restic

        # system monitoring
        btop
        # powertop

        pv
        zoxide
        lazygit
        nvimpager
        zotero
        texliveFull
        # blender (does not work in ubuntu)
        # dbeaver-bin # moved to flathub 
        # libreoffice # moved to flathub
        # inkscape    # moved to flathub
        # vlc         # moved to flathub
        cmake
        neofetch
        htop
        ollama
        google-cloud-sdk
        terraform
        gh # github cli
        git-lfs
        ffmpeg
        findutils
        opencv
        # audio vide editing
        # audacity
        # thunderbird
        imagemagick

        # programming
        go
        rustc
        rustfmt
        #python
        pipx
        poetry
        virtualenv
        ruff
        ruff-lsp
        #node
        #git
        nodejs_22
        tree-sitter
        ## libraries
        boost
        ## performance analysis
        hotspot # gui for perf plots

        # pdf
        zathura
      ];
    };
  };
}

