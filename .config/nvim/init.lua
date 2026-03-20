-- bootstrap lazy.nvim, LazyVim and your plugins
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("silent !kitty @ set-spacing margin=0")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.cmd("silent !kitty @ set-spacing margin=21.75")
  end,
})

require("config.lazy")

-- terminal colour sync
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then
      return
    end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027]111\027\\")
  end,
})
