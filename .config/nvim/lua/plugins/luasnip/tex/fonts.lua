-- Visual placeholder
-- taken from https://ejmastnak.com/

local get_visual = function(args, parent, default_text)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1, default_text))
  end
end

local function v(pos, default_text)
  return d(pos, function(args, parent)
    return get_visual(args, parent, default_text)
  end)
end

local font_snippets = {
  s({ trig = "tny", name = "Tiny font size" }, t("\\tiny")),
  s({ trig = "scr", name = "Scriptize font size" }, t("\\scriptsize")),
  s({ trig = "fot", name = "Footnote size" }, t("\\footnotesize")),
  s({ trig = "sma", name = "Small font size" }, t("\\small")),
  s({ trig = "nor", name = "Normalsize font" }, t("\\normalsize")),
  s({ trig = "lar", name = "Large font size" }, c(1, { t("\\large"), t("\\Large"), t("\\LARGE") })),
  s({ trig = "hug", name = "Huge font size" }, c(1, { t("\\huge"), t("\\Huge") })),
}

local fonts = {
  rm = { cmd = "textrm", env = "rmfamily" },
  sf = { cmd = "textsf", env = "sffamily" },
  tt = { cmd = "texttt", env = "ttfamily" },
  bf = { cmd = "textbf", env = "bfseries" },
  it = { cmd = "textit", env = "itshape" },
  sc = { cmd = "textsc", env = "scshape" },
  em = { cmd = "emph", env = "em" },
  tn = { cmd = "textnormal", env = "normalfont" },
}

for trig, data in pairs(fonts) do
  table.insert(
    font_snippets,
    s(
      { trig = trig, name = data.cmd },
      c(1, {
        fmta([[\]] .. data.cmd .. [[{<>}]], { v(1, "text") }),
        fmta([[\begin{]] .. data.env .. [[} <> \end{]] .. data.env .. [[}]], { v(1, "text") }),
        t([[\]] .. data.env),
      })
    )
  )
end

return font_snippets
