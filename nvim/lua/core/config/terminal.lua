vim.keymap.set("n", "<leader>z", function()
    vim.cmd('!tmux resize-pane -Z && tmux refresh-client -S')
    vim.cmd('redraw!')
end, { silent = true })

