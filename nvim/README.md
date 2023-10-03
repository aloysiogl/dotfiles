```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
```

TODOS:
File explorer:
- [ ] On hover, be able to preview the current file
- [ ] Make git stuff work well on nvim tree
- [ ] Telescope to open when nvim into dir https://www.reddit.com/r/neovim/comments/mtay0q/telescope_into_a_directory/
- [ ] Solution to copy and move files easily when using netrw or similar

Navigation:
- [ ] Understand what other modes of flash do I have available
- [ ] Find fuzzy finder for grep in all files (you had that before)
- [ ] Investigate telescope fuzzy command search with :cmap

Git:
- [ ] Take a look at all other telescope features for LazyGit and Fugitive
- [ ] Improve git experience in git diff pre-commit view with fugitive by previewing the diff under cursor
- [ ] Learn how to integrate diffview

LSP:
- [ ] Make copilot completions actually work for multiple lines, might need to go the tpopes plugin
- [ ] Improve fixes provided by the language server with better mappings
- [ ] Add new languages support for org mode
- [ ] Add python language server
- [ ] Add typescript and language support for javascript coding in vim

Snippets:
- [ ] When leave insert in a snippet with multiple options be able to pass to the next field
- [ ] When using a snip that takes visual mode input automatically leace insert mode once it added the snippet
- [ ] Use regtrig for automatic snippets especially begin for example

Miscellaneous:
- [ ] Have a session manager
- [ ] Look other folkes plugins
- [ ] Keep the same open files when I open or clise directory (save state)
- [ ] Study if mini comment would not be a better alternative for commenting

Done:
- [X] Configure spectre
- [X] Configure whichkey
- [X] In telescope make q quit
- [X] Look at the keymaps in the defautl site for K (it is for lsp) and remap that
- [X] In lazygit you should add syntax highlight
- [X] Possibly change back to easymotion for small motions
- [X] Find fuzzy finder for current file in /, maybe use telescope fuzzy finder? (type :Telescope current_buffer_fuzzy_find)
- [X] Center screen after back from search
- [X] Keep always a part of your screeen with you
