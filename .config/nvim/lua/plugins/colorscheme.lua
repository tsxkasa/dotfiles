local clear = {}
local transparent_background = false
---@class palette
---@type nil|palette
local palette = nil

---Initialize the palette
---@return palette
local function init_palette()
  -- Reinitialize the palette on event `ColorScheme`
  if not _has_autocmd then
    _has_autocmd = true
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("__builtin_palette", { clear = true }),
      pattern = "*",
      callback = function()
        palette = nil
        init_palette()
        -- Also refresh hard-coded hl groups
        M.gen_alpha_hl()
        M.gen_lspkind_hl()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end

  if not palette then
    palette = (vim.g.colors_name or ""):find("catppuccin") and require("catppuccin.palettes").get_palette()
      or {
        rosewater = "#DC8A78",
        flamingo = "#DD7878",
        mauve = "#CBA6F7",
        pink = "#F5C2E7",
        red = "#E95678",
        maroon = "#B33076",
        peach = "#FF8700",
        yellow = "#F7BB3B",
        green = "#AFD700",
        sapphire = "#36D0E0",
        blue = "#61AFEF",
        sky = "#04A5E5",
        teal = "#B5E8E0",
        lavender = "#7287FD",

        text = "#F2F2BF",
        subtext1 = "#BAC2DE",
        subtext0 = "#A6ADC8",
        overlay2 = "#C3BAC6",
        overlay1 = "#988BA2",
        overlay0 = "#6E6B6B",
        surface2 = "#6E6C7E",
        surface1 = "#575268",
        surface0 = "#302D41",

        base = "#1D1536",
        mantle = "#1C1C19",
        crust = "#161320",
      }
  end

  return palette
end
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
      local base24 = require("config.colors-base24")
      local utils = require("catppuccin.utils.colors")

      local steps = 2
      local interpolated = {}
      for i = 1, steps do
        local t = i / (steps + 1)
        table.insert(interpolated, utils.blend(base24.base04, base24.base05, t))
      end

      opts.integrations = {
        cmp = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        dropbar = { enabled = true, color_mode = true },
        fidget = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        grug_far = true,
        hop = true,
        indent_blankline = { enabled = true, colored_indent_levels = true },
        lsp_saga = true,
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        notify = true,
        nvimtree = true,
        rainbow_delimiters = true,
        render_markdown = true,
        semantic_tokens = true,
        telescope = { enabled = true, style = "nvchad" },
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      }

      opts.color_overrides = {
        mocha = {
          rosewater = base24.base14,
          flamingo = base24.base0f,
          pink = base24.base17,
          mauve = base24.base0e,
          red = base24.base08,
          maroon = base24.base12,
          peach = base24.base09,
          yellow = base24.base0a,
          green = base24.base0b,
          teal = base24.base0c,
          sky = base24.base15,
          sapphire = base24.base16,
          blue = base24.base0d,
          lavender = base24.base13,
          text = base24.base07,
          subtext1 = base24.base06,
          subtext0 = base24.base05,
          overlay2 = interpolated[1],
          overlay1 = interpolated[2],
          overlay0 = base24.base04,
          surface2 = base24.base03,
          surface1 = base24.base02,
          surface0 = base24.base01,
          base = base24.base00,
          mantle = base24.base10,
          crust = base24.base11,
        },
      }

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

      opts.highlight_overrides = {
        ---@param cp palette
        all = function(cp)
          return {
            -- For base configs
            NormalFloat = { fg = cp.text, bg = transparent_background and cp.none or cp.mantle },
            FloatBorder = {
              fg = transparent_background and cp.blue or cp.mantle,
              bg = transparent_background and cp.none or cp.mantle,
            },
            CursorLineNr = { fg = cp.green },

            -- For native lsp configs
            DiagnosticVirtualTextError = { bg = cp.none },
            DiagnosticVirtualTextWarn = { bg = cp.none },
            DiagnosticVirtualTextInfo = { bg = cp.none },
            DiagnosticVirtualTextHint = { bg = cp.none },
            LspInfoBorder = { link = "FloatBorder" },

            -- For mason.nvim
            MasonNormal = { link = "NormalFloat" },

            -- For indent-blankline
            IblIndent = { fg = cp.surface0 },
            IblScope = { fg = cp.surface2, style = { "bold" } },

            -- For nvim-cmp and wilder.nvim
            Pmenu = { fg = cp.overlay2, bg = transparent_background and cp.none or cp.base },
            PmenuBorder = { fg = cp.surface1, bg = transparent_background and cp.none or cp.base },
            PmenuSel = { bg = cp.green, fg = cp.base },
            CmpItemAbbr = { fg = cp.overlay2 },
            CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
            CmpDoc = { link = "NormalFloat" },
            CmpDocBorder = {
              fg = transparent_background and cp.surface1 or cp.mantle,
              bg = transparent_background and cp.none or cp.mantle,
            },

            -- For fidget
            FidgetTask = { bg = cp.none, fg = cp.surface2 },
            FidgetTitle = { fg = cp.blue, style = { "bold" } },

            -- For nvim-notify
            NotifyBackground = { bg = cp.base },

            -- For nvim-tree
            NvimTreeRootFolder = { fg = cp.pink },
            NvimTreeIndentMarker = { fg = cp.surface2 },

            -- For trouble.nvim
            TroubleNormal = { bg = transparent_background and cp.none or cp.base },
            TroubleNormalNC = { bg = transparent_background and cp.none or cp.base },

            -- For telescope.nvim
            TelescopeMatching = { fg = cp.lavender },
            TelescopeResultsDiffAdd = { fg = cp.green },
            TelescopeResultsDiffChange = { fg = cp.yellow },
            TelescopeResultsDiffDelete = { fg = cp.red },

            -- For glance.nvim
            GlanceWinBarFilename = { fg = cp.subtext1, style = { "bold" } },
            GlanceWinBarFilepath = { fg = cp.subtext0, style = { "italic" } },
            GlanceWinBarTitle = { fg = cp.teal, style = { "bold" } },
            GlanceListCount = { fg = cp.lavender },
            GlanceListFilepath = { link = "Comment" },
            GlanceListFilename = { fg = cp.blue },
            GlanceListMatch = { fg = cp.lavender, style = { "bold" } },
            GlanceFoldIcon = { fg = cp.green },

            -- For treesitter
            ["@keyword.return"] = { fg = cp.pink, style = clear },
            ["@error.c"] = { fg = cp.none, style = clear },
            ["@error.cpp"] = { fg = cp.none, style = clear },
          }
        end,
      }
    end,
  },
}

-- return {
--   "catppuccin/nvim",
--   lazy = true,
--   name = "catppuccin",
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "catppuccin",
--     },
--   },
--   opts = {
--     lsp_styles = {
--       underlines = {
--         errors = { "undercurl" },
--         hints = { "undercurl" },
--         warnings = { "undercurl" },
--         information = { "undercurl" },
--       },
--     },
--     integrations = {
--       aerial = true,
--       alpha = true,
--       cmp = true,
--       dashboard = true,
--       flash = true,
--       fzf = true,
--       grug_far = true,
--       gitsigns = true,
--       headlines = true,
--       illuminate = true,
--       indent_blankline = { enabled = true },
--       leap = true,
--       lsp_trouble = true,
--       mason = true,
--       mini = true,
--       navic = { enabled = true, custom_bg = "lualine" },
--       neotest = true,
--       neotree = true,
--       noice = true,
--       notify = true,
--       snacks = true,
--       telescope = true,
--       treesitter_context = true,
--       which_key = true,
--     },
--   },
--   specs = {
--     {
--       "akinsho/bufferline.nvim",
--       optional = true,
--       opts = function(_, opts)
--         if (vim.g.colors_name or ""):find("catppuccin") then
--           opts.highlights = require("catppuccin.special.bufferline").get_theme()
--         end
--       end,
--     },
--   },
-- }
