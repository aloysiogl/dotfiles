# Install packages
```zsh
cat my-arch-packages.txt | yay -S --needed -
```
The '-' tells yay to read from the piped input, needed only installs if not installed (so says gemini)

# List packages
```zsh
pacman -Qeq > arch-packages.txt
```
-Qe lists explicitly installed packages
-q makes the output "quiet" (just names, no version numbers)
