-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- quit all
keymap.set("n", "<leader>qq", "<cmd>quitall<CR>", { desc = "quit all" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

