return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    {
      "lazyvim/lazyvim",
      opts = {
        colorscheme = "catppuccin-macchiato",
      },
    },

    opts = function(_, opts)
      -- opts.integrations = {
      --   cmp = true,
      --   dap = true,
      --   dap_ui = true,
      --   diffview = true,
      --   dropbar = { enabled = true, color_mode = true },
      --   fidget = true,
      --   flash = true,
      --   fzf = true,
      --   gitsigns = true,
      --   grug_far = true,
      --   hop = true,
      --   indent_blankline = { enabled = true, colored_indent_levels = true },
      --   lsp_saga = true,
      --   lsp_trouble = true,
      --   markdown = true,
      --   mason = true,
      --   mini = { enabled = true },
      --   native_lsp = {
      --     enabled = true,
      --     virtual_text = {
      --       errors = { "italic" },
      --       hints = { "italic" },
      --       warnings = { "italic" },
      --       information = { "italic" },
      --     },
      --     underlines = {
      --       errors = { "underline" },
      --       hints = { "underline" },
      --       warnings = { "underline" },
      --       information = { "underline" },
      --     },
      --   },
      --   notify = true,
      --   nvimtree = true,
      --   rainbow_delimiters = true,
      --   render_markdown = true,
      --   semantic_tokens = true,
      --   telescope = { enabled = true, style = "nvchad" },
      --   treesitter = true,
      --   treesitter_context = true,
      --   which_key = true,
      -- }

      opts.styles = {
        comments = { "italic" },
        functions = { "bold" },
        keywords = { "italic" },
        operators = { "bold" },
        conditionals = { "bold" },
        loops = { "bold" },
        booleans = { "bold", "italic" },
        numbers = {},
        types = {},
        strings = {},
        variables = {},
        properties = {},
      }
    end,
  },
}
