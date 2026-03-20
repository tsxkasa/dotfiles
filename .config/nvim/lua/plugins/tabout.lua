return {
  "kawre/neotab.nvim",
  opts = {
    tabkey = "<Tab>",
    reverse_key = "<S-Tab>",
    act_as_tab = true,
    behavior = "nested", ---@type ntab.behavior
    pairs = { ---@type ntab.pair[]
      { open = "(", close = ")" },
      { open = "[", close = "]" },
      { open = "{", close = "}" },
      { open = "'", close = "'" },
      { open = '"', close = '"' },
      -- { open = "`", close = "`" },
      { open = "<", close = ">" },
    },
    smart_punctuators = {
      enabled = false,
      escape = {
        enabled = false,
      },
    },
  },
}
