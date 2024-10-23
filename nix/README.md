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

## Todos

- [ ] Learn to use `https://www.nixhub.io/` to find past versions of packages.
