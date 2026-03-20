return {
  "goolord/alpha-nvim",
  event = { "VimEnter", "BufWinEnter" },
  enabled = true,
  init = false,

  opts = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.opts.hl = "AlphaHeader"

    -- Define pastel rainbow colors
    local rainbow_colors = {
      "#FFB3BA",
      "#FFDFBA",
      "#FFFFBA",
      "#BAFFC9",
      "#BAE1FF",
      "#D7BAFF",
      "#FFBAF2",
      "#BAFFD9",
      "#FFDAC1",
    }

    local function button(sc, txt, keybind, keybind_opts)
      -- Ensure keybind defaults to shortcut if not provided
      keybind = keybind or sc
      keybind_opts = keybind_opts or { noremap = true, silent = true, nowait = true }

      -- Create a pastel rainbow highlight based on the first character
      local first_char = sc:sub(1, 1)
      local color_index = (first_char:byte() % #rainbow_colors) + 1
      local key_color = rainbow_colors[color_index]
      local hl_group = "AlphaShortcut_" .. first_char
      vim.cmd(string.format("highlight %s guifg=%s gui=bold", hl_group, key_color))

      local opts = {
        position = "center",
        shortcut = sc,
        cursor = 3,
        width = 50,
        align_shortcut = "right",
        hl = "AlphaButtons", -- description highlight
        hl_shortcut = hl_group, -- shortcut highlight
        keymap = { "n", sc, keybind, keybind_opts },
      }

      local function on_press()
        local key = vim.api.nvim_replace_termcodes(sc .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
      end

      return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
      }
    end

    dashboard.section.buttons.val = {
      -- dashboard.button("f", " " .. " Find file", "<cmd> lua Snacks.picker.files() <cr>"),
      -- dashboard.button("n", " " .. " New file", [[<cmd> ene | startinsert <cr>]]),
      -- dashboard.button("r", " " .. " Recent files", [[<cmd> lua Snacks.picker.recent() <cr>]]),
      -- dashboard.button("p", " " .. " Projects", [[<cmd> lua Snacks.picker.projects() <cr>]]),
      -- dashboard.button("g", " " .. " Find text", [[<cmd> lua Snacks.picker.grep() <cr>]]),
      -- dashboard.button(
      -- 	"c",
      -- 	" " .. " Config",
      -- 	'<cmd> lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) <cr>'
      -- ),
      -- dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      -- dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
      -- dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
      button("f", "  Find file", "<cmd> lua Snacks.picker.files() <cr>"),
      button("n", "  New file", [[<cmd> ene | startinsert <cr>]]),
      button("r", "  Recent files", [[<cmd> lua Snacks.picker.recent() <cr>]]),
      button("p", "  Projects", [[<cmd> lua Snacks.picker.projects() <cr>]]),
      button("g", "  Find text", [[<cmd> lua Snacks.picker.grep() <cr>]]),
      button("c", "  Config", '<cmd> lua Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) <cr>'),
      button("s", "  Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      button("x", "  Lazy Extras", "<cmd> LazyExtras <cr>"),
      button("l", "󰒲  Lazy", "<cmd> Lazy <cr>"),
      button("q", "  Quit", "<cmd> qa <cr>"),
    }

    dashboard.section.buttons.opts.hl = "AlphaButtons"

    local function footer()
      local stats = require("lazy").stats()
      local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
      return "   Have Fun with Neovim"
        .. "  󰀨 v"
        .. vim.version().major
        .. "."
        .. vim.version().minor
        .. "."
        .. vim.version().patch
        .. "  󰂖 "
        .. stats.count
        .. " plugins in "
        .. ms
        .. "ms"
    end

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = "AlphaFooter"

    local head_butt_padding = 2
    local occu_height = #dashboard.section.header.val + 2 * #dashboard.section.buttons.val + head_butt_padding
    local header_padding = math.max(0, math.ceil((vim.fn.winheight(0) - occu_height) * 0.25))
    local foot_butt_padding = 1

    dashboard.config.layout = {
      { type = "padding", val = header_padding },
      dashboard.section.header,
      { type = "padding", val = head_butt_padding },
      dashboard.section.buttons,
      { type = "padding", val = foot_butt_padding },
      dashboard.section.footer,
    }
    return dashboard
  end,

  config = function(_, dashboard)
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "   Have Fun with Neovim"
          .. "  󰀨 v"
          .. vim.version().major
          .. "."
          .. vim.version().minor
          .. "."
          .. vim.version().patch
          .. "  󰂖 "
          .. stats.count
          .. " plugins in "
          .. ms
          .. "ms"

        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
