-- Debugging Support
return {
  -- https://github.com/rcarriga/nvim-dap-ui
  'rcarriga/nvim-dap-ui',
  event = 'VeryLazy',
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    {'mfussenegger/nvim-dap',

  keys = {
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      dap_icons = {
        Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint          = " ",
        BreakpointCondition = " ",
        BreakpointRejected  = { " ", "DiagnosticError" },
        LogPoint            = ".>",
      }

      for name, sign in pairs(dap_icons) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,

    },
    -- https://github.com/mfussenegger/nvim-dap-python
    {'mfussenegger/nvim-dap-python',
      ft='python',
      dependencies ={
        'mfussenegger/nvim-dap',
        'rcarriga/nvim-dap-ui',
      },
      config = function(_, opts)
        local path ="~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require('dap-python').setup(path)
      end,
    },
    -- https://github.com/nvim-neotest/nvim-nio
    'nvim-neotest/nvim-nio',
    -- https://github.com/theHamsta/nvim-dap-virtual-text
    'theHamsta/nvim-dap-virtual-text', -- inline variable text while debugging
    -- https://github.com/nvim-telescope/telescope-dap.nvim
    'nvim-telescope/telescope-dap.nvim', -- telescope integration with dap
  },
  opts = {
    controls = {
      element = "repl",
      enabled = false,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      collapsed = "",
      current_frame = "",
      expanded = ""
    },
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.50
          },
          {
            id = "stacks",
            size = 0.30
          },
          {
            id = "watches",
            size = 0.10
          },
          {
            id = "breakpoints",
            size = 0.10
          }
        },
        size = 40,
        position = "left", -- Can be "left" or "right"
      },
      {
        elements = {
          "repl",
          "console",
        },
        size = 10,
        position = "bottom", -- Can be "bottom" or "top"
      }
    },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  },
  config = function (_, opts)
    local dap = require('dap')
    require('dapui').setup(opts)

    dap.listeners.after.event_initialized["dapui_config"] = function()
      require('dapui').open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      require('dapui').close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      -- Commented to prevent DAP UI from closing when unit tests finish
      require('dapui').close()
    end

    -- Add dap configurations based on your language/adapter settings
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- dap.configurations.xxxxxxxxxx = {
    --   {
    --   },
    -- }
  end
}

