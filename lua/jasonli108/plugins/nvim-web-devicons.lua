return {{
  "nvim-tree/nvim-web-devicons",
  config = function()
    require("nvim-web-devicons").set_icon({
      gql = {
        icon = "",
        color = "#e535ab",
        cterm_color = "199",
        name = "GraphQL",
      },
    })
  end,
},

{
  "echasnovski/mini.icons",
  lazy = true,
  opts = {
    file = {
      [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
  },
  init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
}
