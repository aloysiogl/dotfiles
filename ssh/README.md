# SSH config (GitHub / GitLab)

This config uses the **SSH agent** and **macOS Keychain** so you type your key passphrase only once per session (or after reboot) instead of on every `git push`, `git pull`, etc.

- **Keychain**: macOS stores your SSH key passphrase there after you enter it once; the agent reads it when needed.
- **Host**: The config applies only to `github.com` and `gitlab.com`. Other hosts are unchanged.

## Install

Link this config as your SSH config:

```bash
mkdir -p ~/.ssh
ln -sf ~/.dotfiles/ssh/config ~/.ssh/config
```

## One-time setup

Add your key to the agent and store its passphrase in Keychain (you’ll be prompted once):

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

If your key has another name (e.g. `id_rsa`), use that path and update the `IdentityFile` line in `ssh/config` to match.

## Result

After this, the first git remote action (or SSH to GitHub/GitLab) in a session may ask for your passphrase once; later uses use the cached key and won’t prompt until you log out or restart (depending on Keychain settings).

## To verify and erase:
It is not possible to add private key to Keychain, but you can store passphrase for private key in Keychain. On OSX, the native ssh-add command has a special argument to save the private key's passphrase in the OSX Keychain, which means that your normal login will unlock it for use with ssh. On OSX Sierra and later, you also need to configure SSH to always use the Keychain (see Step 2 below).

Alternatively you can use a key without a passphrase, but if you prefer the security that's certainly acceptable with this workflow.

Step 1 - Store passphrase in the Keychain
In the latest version of MacOS (12.0 Monterey), just do this once:

ssh-add --apple-use-keychain ~/.ssh/[your-private-key]
Or in versions of MacOS older than 12.0 Monterey, use:

ssh-add -K ~/.ssh/[your-private-key]
Enter your key passphrase, and you won't be asked for it again.

(If this fails, make sure you are using Apple's version of /usr/bin/ssh-add and not something installed with brew etc.; check with which ssh-add)

Step 2 - Configure SSH-agent to always use the Keychain
(Note: In versions of OSX prior to Sierra, this is not necessary)

It seems that OSX Sierra removed the convenient behavior of persisting your keys between logins, and the update to ssh no longer uses the keychain by default. Because of this, you need to change one more thing for secure persistent key storage.

The solution is outlined in this github thread comment. Here's what you do:

Ensure you've completed Step 1 above to store the passphrase in the keychain.

If you haven't already, create an ~/.ssh/config file. In other words, in the .ssh directory in your home dir, make a file called config.

In that .ssh/config file, add the following lines:

Host *
    UseKeychain yes
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_rsa
Change ~/.ssh/id_rsa to the actual filename of your private key. If you have other private keys in your ~/.ssh directory, also add an IdentityFile line for each of them. For example, I have one additional line that reads IdentityFile ~/.ssh/id_ed25519 for a 2nd private key.

The UseKeychain yes is the key part, which tells SSH to look in your OSX keychain for the key passphrase.

Step 3 - Configure your shell to load the Keychain
Add the following to your ~/.zshrc file:

ssh-add --apple-load-keychain -q
(-q to not print success message)

That's it! Next time you load any ssh connection, it will try the private keys you've specified, and it will look for their passphrase in the OSX keychain. No passphrase typing required.

Share
Improve this answer
Follow
edited Sep 3, 2025 at 21:24
Kuba Holuj's user avatar
Kuba Holuj
10322 bronze badges
answered Aug 26, 2016 at 1:06
xxx's user avatar
xxx
13.8k11 gold badge1818 silver badges88 bronze badges
9
@Poulsbo & @Abram -- see my update, Sierra changed the automatic behavior and now you have to run ssh-add -A manually to load your saved keychain. Some possible solutions referenced above. – 
xxx
 CommentedJan 3, 2017 at 22:20
21
Works great! In my case I needed to use the A flag in addition to the K one to add my keys to the keychain and register the passphrase into it (ssh-add -AK ~/.ssh/[your-private-key]). Thanks! – 
youssman
 CommentedMar 7, 2017 at 22:28 
7
Even with the usekeychain option, I still find that my keychain will drop the .ssh/id_rsa key on reboot. – 
Chogg
 CommentedMay 2, 2018 at 18:39
12
I did exactly the same and my Mac still drops the key on reboot. – 
Ernest Zamelczyk
 CommentedNov 22, 2018 at 8:57
10
I had to also add ssh-add --apple-load-keychain 2> /dev/null to my `.zshrc to get this to work on reboots. – 
aiguofer
 CommentedDec 15, 2022 at 23:28
Show 28 more comments