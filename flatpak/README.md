# Flatpak

## Back up:

```bash
flatpak list --app --columns=application > flatpaks.txt
```

Alternatively:

```bash
flatpak list --app --columns=ref > flatpaks.txt
```

## Load:

```bash
xargs flatpak install --user -y < flatpaks.txt
```

## Add Flathub:

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

