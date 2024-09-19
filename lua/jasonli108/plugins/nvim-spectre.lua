return {
  "nvim-pack/nvim-spectre",
  build = false,
  cmd = "Spectre",
  opts = { open_cmd = "noswapfile vnew" },
  keys = {
    {
      "<leader>rr",
      function()
        require("spectre").open()
      end,
      desc = "replace in files (Spectre)",
    },
  },
}
