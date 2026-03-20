return {
  {
    "saghen/blink.compat",
    lazy = true,
    optional = true,
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },

    version = "*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        preset = "luasnip",

        active = function(filter)
          local luasnip = require("luasnip")

          if filter and filter.direction then
            return luasnip.jumpable(filter.direction)
          end

          return luasnip.in_snippet()
        end,

        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },

        ["<Tab>"] = {
          -- "snippet_forward",
          function(cmp)
            local luasnip = require("luasnip")

            if luasnip.in_snippet() and luasnip.jumpable(1) then
              return cmp.snippet_forward()
            end

            if cmp.is_visible() then
              return cmp.select_next()
            end
          end,
          "fallback",
        },

        ["<S-Tab>"] = {
          function(cmp)
            local luasnip = require("luasnip")

            if cmp.is_visible() then
              return cmp.select_prev()
            end

            if luasnip.in_snippet() and luasnip.jumpable(-1) then
              return cmp.snippet_backward()
            end
          end,
          "fallback",
        },

        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-up>"] = { "scroll_documentation_up", "fallback" },
        ["<C-down>"] = { "scroll_documentation_down", "fallback" },
      },

      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },

      sources = {
        default = { "lsp", "snippets" },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      cmdline = { enabled = false },

      completion = {
        menu = {
          border = "rounded",
          draw = {
            columns = {
              { "kind_icon", "label", gap = 1 },
              { "kind" },
            },
            components = {
              kind_icon = {
                text = function(item)
                  local kind = require("lspkind").symbol_map[item.kind] or ""
                  return kind .. " "
                end,
                highlight = "CmpItemKind",
              },
              label = {
                text = function(item)
                  return item.label
                end,
                highlight = "CmpItemAbbr",
              },
              kind = {
                text = function(item)
                  return item.kind
                end,
                highlight = "CmpItemKind",
              },
            },
          },
          cmdline_position = function()
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              return { pos[1] - 1, pos[2] }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
        },

        accept = {
          auto_brackets = { enabled = true },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },
        trigger = {
          show_in_snippet = true,
          show_on_trigger_character = true,
          show_on_insert = true,
          show_on_insert_on_trigger_character = true,
        },
        list = {
          selection = {
            preselect = function(ctx)
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
        },
      },
    },
  },
}

-- return {
--   "hrsh7th/nvim-cmp",
--   version = false,
--   event = "InsertEnter",
--   dependencies = {
--     "kdheepak/cmp-latex-symbols",
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer",
--     "hrsh7th/cmp-path",
--   },
--
--   opts = function()
--     local border = function(hl)
--       return {
--         { "┌", hl },
--         { "─", hl },
--         { "┐", hl },
--         { "│", hl },
--         { "┘", hl },
--         { "─", hl },
--         { "└", hl },
--         { "│", hl },
--       }
--     end
--     local cmp = require("cmp")
--     local luasnip = require("luasnip")
--     return {
--       preselect = cmp.PreselectMode.None,
--       window = {
--         completion = {
--           border = border("PmenuBorder"),
--           winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:PmenuSel",
--           scrollbar = false,
--         },
--         documentation = {
--           border = border("CmpDocBorder"),
--           winhighlight = "Normal:CmpDoc",
--         },
--       },
--       matching = {
--         disallow_partial_fuzzy_matching = false,
--       },
--       performance = {
--         async_budget = 1,
--         max_view_entries = 120,
--         debounce = 0, -- default is 60ms
--         throttle = 0, -- default is 30ms
--       },
--       mapping = cmp.mapping.preset.insert({
--         ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
--         ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
--         ["<C-d>"] = cmp.mapping.scroll_docs(-4),
--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
--         ["<C-w>"] = cmp.mapping.abort(),
--         ["<Tab>"] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
--           elseif luasnip.expand_or_locally_jumpable() then
--             luasnip.expand_or_jump()
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--         ["<S-Tab>"] = cmp.mapping(function(fallback)
--           if cmp.visible() then
--             cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
--           elseif luasnip.jumpable(-1) then
--             luasnip.jump(-1)
--           else
--             fallback()
--           end
--         end, { "i", "s" }),
--         ["<CR>"] = cmp.mapping({
--           i = function(fallback)
--             if cmp.visible() and cmp.get_active_entry() then
--               cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
--             else
--               fallback()
--             end
--           end,
--           s = cmp.mapping.confirm({ select = true }),
--           c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
--         }),
--       }),
--       sources = cmp.config.sources({
--         { name = "nvim_lsp", max_item_count = 350 },
--         { name = "luasnip" },
--         { name = "path" },
--         {
--           name = "buffer",
--           option = {
--             get_bufnrs = function()
--               return vim.api.nvim_buf_line_count(0) < 15000 and vim.api.nvim_list_bufs() or {}
--             end,
--           },
--         },
--         { name = "latex_symbols" },
--       }),
--       snippet = {
--         expand = function(args)
--           luasnip.lsp_expand(args.body)
--         end,
--       },
--     }
--   end,
-- }
