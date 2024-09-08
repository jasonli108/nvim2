kind_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
}

---@param buf? number
---@return string[]?
function get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if kind_filter == false then
    return
  end
  if kind_filter[ft] == false then
    return
  end
  if type(kind_filter[ft]) == "table" then
    return kind_filter[ft]
  end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
end

function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    -- 'neovim/nvim-lspconfig',
    { "nvim-tree/nvim-web-devicons" },
    -- { 'mfussenegger/nvim-dap',}
    --
  },
  cmd = "FzfLua",
  opts = function(_, opts)
    local actions = require("fzf-lua.actions")
    require("fzf-lua").setup({
      winopts = {
        hl = {
          border = "FloatBorder",
        },
      },
      preview_layout = "flex",
      flip_columns = 150,
      fzf_opts = {
        ["--border"] = "none",
      },
      previewers = {
        builtin = {
          scrollbar = false,
        },
      },
      grep = {
        actions = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },
      buffers = {
        git_icons = false,
        actions = {
          ["ctrl-w"] = actions.buf_del,
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },
      files = {
        fd_opts = [[--color never --type f --hidden --follow --strip-cwd-prefix]],
        git_icons = false,
        actions = {
          ["default"] = actions.file_edit,
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },
      quickfix = {
        git_icons = false,
        actions = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },
      lsp = {
        async_or_timeout = false,
        severity = "Warning",
        -- icons = {
        --   ['Error'] = { icon = vim.g.diagnostic_icons.Error, color = 'red' },
        --   ['Warning'] = { icon = vim.g.diagnostic_icons.Warning, color = 'yellow' },
        --   ['Information'] = { icon = vim.g.diagnostic_icons.Information, color = 'blue' },
        --   ['Hint'] = { icon = vim.g.diagnostic_icons.Hint, color = 'blue' },
        -- },
        actions = {
          ["default"] = actions.file_edit_or_qf,
          ["ctrl-q"] = actions.file_sel_to_qf,
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
    { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    -- find
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
    { "<leader>fc", "<cmd>FzfLua config_files()<cr>", desc = "Find Config File" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
    { "<leader>fF", "<cmd>FzfLua files({ root = false })<cr>", desc = "Find Files (cwd)" },
    { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    { "<leader>fR", "<cmd>FzfLua oldfiles({ cwd = vim.uv.cwd() })<cr>", desc = "Recent (cwd)" },
    -- git
    { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
    { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
    -- search
    { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
    { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
    { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
    { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
    { "<leader>sG", "<cmd>FzfLua live_grep({ root = false })<cr>", desc = "Grep (cwd)" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
    { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
    { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
    { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
    { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
    { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
    { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (Root Dir)" },
    { "<leader>sW", "<cmd>FzfLua grep_cword({ root = false })<cr>", desc = "Word (cwd)" },
    { "<leader>sw", "<cmd>FzfLua grep_visual<cr>", desc = "Selection (Root Dir)" },
    { "<leader>sW", "<cmd>FzfLua grep_visual({ root = false })<cr>", desc = "Selection (cwd)" },
    { "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols({
          regex_filter = symbols_filter,
        })
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("fzf-lua").lsp_live_workspace_symbols({
          regex_filter = symbols_filter,
        })
      end,
      desc = "Goto Symbol (Workspace)",
    },

    --lsp
    {
      "gd",
      "<cmd>FzfLua lsp_definitions     jump_to_single_result=true ignore_current_line=true<cr>",
      desc = "Goto Definition",
    },
    {
      "gr",
      "<cmd>FzfLua lsp_references      jump_to_single_result=true ignore_current_line=true<cr>",
      desc = "References",
      nowait = true,
    },
    {
      "gI",
      "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>",
      desc = "Goto Implementation",
    },
    {
      "gy",
      "<cmd>FzfLua lsp_typedefs        jump_to_single_result=true ignore_current_line=true<cr>",
      desc = "Goto T[y]pe Definition",
    },

    -- { "<leader>d", "<cmd>FzfLua lsp_document_diagnostics<CR>", desc = "lsp_document_diagnostics" },
    { "<leader>gd", "<cmd>FzfLua lsp_definitions<CR>", desc = "lsp_definition" },
    { "<leader>gr", "<cmd>FzfLua lsp_references<CR>", desc = "lsp_references" },
    { "<leader>gi", "<cmd>FzfLua lsp_implementations<CR>", desc = "lsp_implementations" },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols({
          regex_filter = symbols_filter,
        })
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("fzf-lua").lsp_live_workspace_symbols({
          regex_filter = symbols_filter,
        })
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
}
