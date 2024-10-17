# How to install

In ubuntu:

```zsh
# nix-env -iA -f config.nix
ln -s ~/.dotfiles/nix/config.nix ~/.config/nixpkgs/config.nix
```

To install new packages do:

```zsh
nix-env -iA nixpkgs.myPackages
```
