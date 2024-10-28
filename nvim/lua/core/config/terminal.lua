vim.keymap.set("n", "<leader>t", function()
    vim.cmd('!tmux resize-pane -Z && tmux refresh-client -S')
    vim.cmd('redraw!')
end, { silent = true })

