return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    ft = { "tex", "latex" },
    dependencies = {
      { "rafamadriz/friendly-snippets", enabled = false },
      -- { "iurimateus/luasnip-latex-snippets.nvim" },
      {
        "lervag/vimtex",
        init = function()
          vim.g.vimtex_imaps_enabled = 0
        end,
      },
    },
    config = function()
      require("luasnip").config.setup({
        history = true,
        delete_check_events = "TextChanged",
        enable_autosnippets = true,
      })
      local ls = require("luasnip")
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end)

      -- require("luasnip-latex-snippets").setup()

      require("luasnip.loaders.from_vscode").lazy_load()

      require("luasnip/loaders/from_lua").lazy_load({ paths = "~/.config/nvim/lua/plugins/luasnip/" })
    end,
  },
}
