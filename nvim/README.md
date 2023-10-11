```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
```

TODOS:
Build:
- [ ] Be able to build latex files correctly and put build errors in quickfix list. Help material:
https://www.reddit.com/r/neovim/comments/iafxvz/asynchronous_make_in_neovim_with_lua/
https://www.ejmastnak.com/tutorials/vim-latex/compilation/#error-parse

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
- [ ] Debug diffview, try to replicate it for my tree view
- [ ] Take a look at all other telescope features for LazyGit and Fugitive
- [ ] Improve git experience in git diff pre-commit view with fugitive by previewing the diff under cursor

LSP:
- [ ] Make my custom citation commmands work on vimtex
- [ ] Migrate to my own lsp config (out of lsp-zero), use config on dreas of code youtube channel for python as base.
- [ ] Add typescript and language support for javascript coding in vim

Snippets:
- [ ] When leave insert in a snippet with multiple options be able to pass to the next field
- [ ] When using a snip that takes visual mode input automatically leace insert mode once it added the snippet
- [ ] Use regtrig for automatic snippets especially begin for example

Miscellaneous:
- [ ] Look other folkes plugins
- [ ] Study if mini comment would not be a better alternative for commenting

Done:
- [X] Have a session manager
- [X] Keep the same open files when I open or clise directory (save state)
- [X] Make copilot as only ghost text (maybe will have to resort to tpope copilot), related to the next point
- [X] Make copilot completions actually work for multiple lines, might need to go the tpopes plugin
- [X] Improve fixes provided by the language server with better mappings
- [X] Add new languages support for org mode
- [X] Add python language server
- [X] Configure spectre
- [X] Configure whichkey
- [X] In telescope make q quit
- [X] Look at the keymaps in the defautl site for K (it is for lsp) and remap that
- [X] In lazygit you should add syntax highlight
- [X] Possibly change back to easymotion for small motions
- [X] Find fuzzy finder for current file in /, maybe use telescope fuzzy finder? (type :Telescope current_buffer_fuzzy_find)
- [X] Center screen after back from search
- [X] Keep always a part of your screeen with you
