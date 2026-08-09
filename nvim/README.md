```bash
ln -s ~/.dotfiles/nvim ~/.config/nvim
```

General remarks:
- In git I want to be able to navigate fast in the files history and this should not be too hard with fugitive for gitsigns.
- It's hard to get in and out of the terminal, should think about shortcuts which work directly from the command mode.
- Should think of an easier way of switching tabs while on a normal keyboard.

## AI agents (CodeCompanion)

CodeCompanion is the shared Neovim interface for Claude Code, Codex, and Cursor.
Claude Code is the default raw terminal agent; Codex is the default structured
ACP chat. Restart the terminal after changing `system/env.zsh` so Neovim can
find the ACP bridge executables.

### Prerequisites

Install the three agent CLIs using their official installers:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
curl -fsSL https://claude.ai/install.sh | bash
curl https://cursor.com/install -fsS | bash
```

References: [Codex CLI](https://learn.chatgpt.com/docs/codex/cli),
[Claude Code](https://code.claude.com/docs/en/setup), and
[Cursor CLI](https://cursor.com/docs/cli/installation).

CodeCompanion's structured Codex and Claude chats use ACP bridge executables.
The dotfiles add `~/.npm-global/bin` to `PATH`, so install them there:

```bash
npm config set prefix "${HOME}/.npm-global"
npm install -g \
  @agentclientprotocol/codex-acp \
  @agentclientprotocol/claude-agent-acp
exec zsh
```

Authenticate each CLI once before opening its CodeCompanion integration:

```bash
codex login
claude
agent login
```

| Mapping | Action |
| --- | --- |
| `<leader>cl` | Open or focus the Claude Code terminal |
| `<leader>co` | Open or focus the Codex terminal |
| `<leader>cu` | Open or focus the Cursor terminal |
| `<leader>cp` | Prompt the active CLI; a visual selection is included |
| `<leader>cr` | Add the current file or visual selection as context |
| `<leader>cd` | Send current-buffer LSP diagnostics to the active CLI |
| `<leader>ct` | Send the most recent terminal output to the active CLI |
| `<leader>cc` | Toggle the current structured chat |
| `<leader>cC` | Start a structured Codex ACP chat |
| `<leader>cL` | Start a structured Claude ACP chat |
| `<leader>cU` | Start a structured Cursor ACP chat |
| `<leader>ca` | Open CodeCompanion actions |
| `<leader>ce` | Edit a visual selection inline using Copilot |

Put the cursor on a file reference and press `gR` to open it in Neovim. In a
raw CLI terminal, first press `jk` to enter terminal-normal mode, then press
`Enter` (or `gR`); references in `path:line:column` format jump directly to that
location in the code pane. In structured chats, `Enter` remains the send key.
Cursor requires a one-time `agent login`. Codex ACP uses the existing ChatGPT
login. Claude's raw terminal uses the existing `claude` login; its ACP bridge
can also use `ANTHROPIC_API_KEY`.

TODOS:
Quickfix list:
- [ ] Be able to select an item and close
- [ ] Maybe change the preview, but I will see that in the future

Build:
- [ ] Be able to build latex files correctly and put build errors in quickfix list. Help material:
https://www.reddit.com/r/neovim/comments/iafxvz/asynchronous_make_in_neovim_with_lua/
https://www.ejmastnak.com/tutorials/vim-latex/compilation/#error-parse

File explorer:
- [ ] Have better and consistent mappings.
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
- [ ] Make my custom reference commmands work on vimtex (actually texlab was the provider, but for some reason reference citations are not shown for vimtex, needs further investigations, for texlab it's unlikely that I can add new reference commmands for now)
- [ ] Migrate to my own lsp config (out of lsp-zero), use config on dreas of code youtube channel for python as base.
- [ ] Add typescript and language support for javascript coding in vim

Snippets:
- [ ] When leave insert in a snippet with multiple options be able to pass to the next field
- [ ] When using a snip that takes visual mode input automatically leace insert mode once it added the snippet
- [ ] Use regtrig for automatic snippets especially begin for example

Miscellaneous:
- [ ] Install undotree
- [ ] Look other folkes plugins
- [ ] Study if mini comment would not be a better alternative for commenting

Done:
- [X] Make my custom citation commmands work on vimtex
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
