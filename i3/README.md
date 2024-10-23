Currently placed under `~/.config/i3/config`

Reload the config with:
`i3-msg reload`
`i3-msg restart`

Problems with Intel integrated graphics and i3. You should try to make nvidia grpahics the default one.

```bash
DRI_PRIME=1 glxinfo | grep OpenGL
glxinfo | grep OpenGL # those should output nvidia
sudo prime-select nvidia # should set the default graphics to nvidia
```

Detect displays with `autorandr`:

```bash
autorandr --save <name>
autorandr --change
```
