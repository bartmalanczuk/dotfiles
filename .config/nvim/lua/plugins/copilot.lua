return {
  {
    "zbirenbaum/copilot.lua",
    opts = {}
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  }
}
