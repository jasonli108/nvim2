return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "rafamadriz/friendly-snippets", -- Optional: A collection of snippets
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
      after = 'nvim-cmp',
      config = function() 
        require("jasonli108.snips")
        -- require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "~/.config/nvim/snippets" } })
        -- local luasnip = require('luasnip')
        --
        -- -- Load friendly-snippets if you installed it
        -- require('luasnip.loaders.from_vscode').load()

        -- Define your custom snippets here (if any)
        -- luasnip.snippets = {
        --     all = {
        --         luasnip.snippet("trig", {
        --             luasnip.text_node("This is a snippet"),
        --         }),
        --     },
        -- }
        --
        local ls = require('luasnip')

        local M = {}

        function M.expand_or_jump()
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end

        function M.jump_next()
          if ls.jumpable(1) then
            ls.jump(1)
          end
        end

        function M.jump_prev()
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end

        function M.change_choice()
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end

        function M.reload_package(package_name)
          for module_name, _ in pairs(package.loaded) do
            if string.find(module_name, '^' .. package_name) then
              package.loaded[module_name] = nil
              require(module_name)
            end
          end
        end

        function M.refresh_snippets()
          ls.cleanup()
          M.reload_package('<update the module name here>')
        end

        local set = vim.keymap.set

        local mode = { 'i', 's' }
        local normal = { 'n' }

        set(mode, '<c-i>', M.expand_or_jump)
        set(mode, '<c-n>', M.jump_prev)
        set(mode, '<c-l>', M.change_choice)
        set(normal, ',r', M.refresh_snippets)
      end,
    },
  },
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    return {
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      sorting = defaults.sorting,
    }
  end,
  config = function(_, opts)
    for _, source in ipairs(opts.sources) do
      source.group_index = source.group_index or 1
    end
    require("cmp").setup(opts)
  end,
}
