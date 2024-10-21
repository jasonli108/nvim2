function local_has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

function get_opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end

  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- This is the same as in lspconfig.server_configurations.jdtls, but avoids
-- needing to require that when this module loads.
local java_filetypes = { "java" }

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
local function extend_or_override(config, custom, ...)
  if type(custom) == "function" then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
  end
  return config
end

return {
  { "folke/which-key.nvim" },
  -- Add java to treesitter.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "java" })
    end,
  },

  -- Ensure java debugger and test packages are installed.
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "java-test", "java-debug-adapter", "google-java-format" })
        end,
      },
    },
  },

  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of nvim-jtdls below.
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jdtls = {},
      },
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },

  -- Set up nvim-jdtls to attach to java files.
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "folke/which-key.nvim" },
    ft = java_filetypes,
    config = function()
      -- JDTLS (Java LSP) configuration
    local jdtls = require('jdtls')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = vim.env.HOME .. '/jdtls-workspace/' .. project_name

        -- Where are the config and workspace dirs for a project?
    local jdtls_config_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
    local jdtls_workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"

    -- Needed for debugging
    local bundles = {
      vim.fn.glob(vim.env.HOME .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'),
    }

    -- Needed for running/debugging unit tests
    vim.list_extend(bundles, vim.split(vim.fn.glob(vim.env.HOME .. "/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

    -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
    local config = {
      cmd = {

        '' .. vim.env.HOME .. '/.local/share/nvim/mason/packages/jdtls/jdtls',
        '--jvm-arg=-javaagent:' .. vim.env.HOME .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
        '-configuration', vim.env.HOME .. jdtls_config_dir,
        '-data', jdtls_workspace_dir
      },

      -- This is the default if not provided, you can remove it. Or adjust as needed.
      -- One dedicated LSP server & client will be started per unique root_dir
      root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'pom.xml', 'build.gradle'}),

      -- Here you can configure eclipse.jdt.ls specific settings
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      settings = {
        java = {
          -- TODO Replace this with the absolute path to your main java version (JDK 17 or higher)
          home = '/usr/lib/jvm/java-22-openjdk-amd64',
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
            -- TODO Update this by adding any runtimes that you need to support your Java projects and removing any that you don't have installed
            -- The runtime name parameters need to match specific Java execution environments.  See https://github.com/tamago324/nlsp-settings.nvim/blob/2a52e793d4f293c0e1d61ee5794e3ff62bfbbb5d/schemas/_generated/jdtls.json#L317-L334
            runtimes = {
              {
                name = "JavaSE-22",
                path = "/usr/lib/jvm/java-22-openjdk-amd64",
              },
              {
                name = "JavaSE-23",
                path = "/usr/lib/jvm/java-23-openjdk-amd64",
              },

            }
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          signatureHelp = { enabled = true },
          format = {
            enabled = true,
            -- Formatting works by default, but you can refer to a specific file/URL if you choose
            -- settings = {
            --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
            --   profile = "GoogleStyle",
            -- },
          },
        },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
          importOrder = {
            "java",
            "javax",
            "com",
            "org"
          },
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      },
      -- Needed for auto-completion with method signatures and placeholders
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      flags = {
        allow_incremental_sync = true,
      },
      init_options = {
        -- References the bundles defined above to support Debugging and Unit Testing
        bundles = bundles
      },
    }


      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)

        -- Configuration can be augmented and overridden by opts.jdtls
        local nconfig = extend_or_override({
          cmd = config.cmd,
          root_dir = config.root_dir,
          init_options = {
            bundles = bundles,
          },
          settings = config.settings,
          -- enable CMP capabilities
          capabilities = config.capabilities,
        }, {})

        -- Existing server will be reused if the root_dir matches.
        require("jdtls").start_or_attach(nconfig)
        -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
      end

    -- Needed for debugging
    config['on_attach'] = function(client, bufnr)
      jdtls.setup_dap({ hotcodereplace = 'auto' })
      require('jdtls.dap').setup_dap_main_class_configs()
    end


      -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
      -- depending on filetype, so this autocmd doesn't run for the first file.
      -- For that, we call directly below.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = java_filetypes,
        callback = attach_jdtls,
      })


    -- This starts a new client & server, or attaches to an existing client & server based on the `root_dir`.
    end,
  },
}
