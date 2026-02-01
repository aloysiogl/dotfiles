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

## Garbage collection

Link: `https://nix.dev/manual/nix/2.18/package-management/garbage-collection`

Delete old generations:

```zsh
nix-env --delete-generations old
```

Run garbage collection on everything:

```zsh
nix-collect-garbage -d
```

## Troubleshooting on first install with arch

### Create the nix-users group

```zsh
sudo groupadd --system nix-users
```

### Add your current user to that group

```zsh
sudo usermod -aG nix-users $(whoami)
```

### Change ownership of the config directory just in case

```zsh
sudo chgrp nix-users /nix/var/nix/daemon-socket
```

### Enable deamon

```zsh
sudo systemctl enable --now nix-daemon.service
```
