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

local format_snippets = {
  s(
    { trig = "tz", name = "Itemize" },
    fmta(
      [[
      \begin{itemize}
          \item <>
      \end{itemize}
    ]],
      { i(1) }
    )
  ),
  s(
    { trig = "enm", name = "Enumerate" },
    fmta(
      [[
      \begin{enumerate}
          \item <>
      \end{enumerate}
    ]],
      { i(1) }
    )
  ),
  s({ trig = "tm", name = "New item" }, fmta([[\item <>]], { i(1) })),

  s({ trig = "url", name = "URLs" }, fmta([[\url{<>}]], { v(1, "url") })),
  s({ trig = "ca", name = "Cancel stroke" }, fmta([[\cancel{<>}]], { v(1, "text") })),
}

local theorems = {
  oo = "theorem",
  pf = "proof",
  ps = "proposition",
  cc = "corollary",
  ll = "lemma",
  dd = "definition",
  re = "remark",
  ex = "exercise",
  ee = "example",
  pn = "principle",
}

for trig, env in pairs(theorems) do
  table.insert(
    format_snippets,
    s(
      { trig = trig, name = env },
      c(1, {
        fmta([[\begin{]] .. env .. [[}
    <>
\end{]] .. env .. [[}]], { v(1, "") }),
        fmta([[\begin{]] .. env .. [[}[<>]
    <>
\end{]] .. env .. [[}]], { i(1, "name"), v(2, "") }),
      })
    )
  )
end

return format_snippets
