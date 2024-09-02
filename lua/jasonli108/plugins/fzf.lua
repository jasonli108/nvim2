return {
  "ibhagwan/fzf-lua",
  cmd = "FzfLua",
  opts = function(_, opts)
    local actions = require('fzf-lua.actions')
    require('fzf-lua').setup({
      winopts = {
        hl = {
          border = 'FloatBorder',
        },
      },
      preview_layout = 'flex',
      flip_columns = 150,
      fzf_opts = {
        ['--border'] = 'none',
      },
      previewers = {
        builtin = {
          scrollbar = false,
        },
      },
      grep = {
        actions = {
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-q'] = actions.file_sel_to_qf,
        },
      },
      buffers = {
        git_icons = false,
        actions = {
          ['ctrl-w'] = actions.buf_del,
          ['ctrl-q'] = actions.file_sel_to_qf,
        },
      },
      files = {
        fd_opts = [[--color never --type f --hidden --follow --strip-cwd-prefix]],
        git_icons = false,
        actions = {
          ['default'] = actions.file_edit,
          ['ctrl-q'] = actions.file_sel_to_qf,
        },
      },
      quickfix = {
        git_icons = false,
        actions = {
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-q'] = actions.file_sel_to_qf,
        },
      },
      lsp = {
        async_or_timeout = false,
        severity = 'Warning',
        -- icons = {
        --   ['Error'] = { icon = vim.g.diagnostic_icons.Error, color = 'red' },
        --   ['Warning'] = { icon = vim.g.diagnostic_icons.Warning, color = 'yellow' },
        --   ['Information'] = { icon = vim.g.diagnostic_icons.Information, color = 'blue' },
        --   ['Hint'] = { icon = vim.g.diagnostic_icons.Hint, color = 'blue' },
        -- },
        actions = {
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-q'] = actions.file_sel_to_qf,
        },
      },
    })
end,

  keys = {
    { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
    { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
    {
      "<leader>,",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    -- find
    { "<leader>fw", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "lsp diagnostics_document" },
    { "<leader>fW", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "lsp_workspace_diagnostics" },
    { "<leader>fs", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>" ,desc = "Grep (Root Dir)" },
    { "<leader>fG", "<cmd>FzfLua live_grep_resume<cr>", desc = "Grep (Root Dir)" },

    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    { "<leader>fF", "<cmd>FzfLua files_resume<cr>", desc = "Find Files (Root Dir) Resume" },
    { "<leader>fd", "<cmd>FzfLua buffers<cr>", desc = "Find Buffer (Root Dir)" },
    { "<leader>fD", "<cmd>FzfLua buffers_resume<cr>", desc = "Find Buffer (Root Dir) Resume" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },


    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
  },
}



