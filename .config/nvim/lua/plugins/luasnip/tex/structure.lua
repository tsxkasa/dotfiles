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

local in_mathzone = function()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

return {
  s(
    { trig = "beg", name = "Generic environment" },
    fmta(
      [[
      \begin{<>}
          <>
      \end{<>}
    ]],
      { i(1, "environment"), v(2, "body"), rep(1) }
    ),
    { condition = not in_mathzone }
  ),

  s(
    { trig = "doc", name = "Document class" },
    c(1, {
      fmta([[\documentclass{<>}]], { i(1, "article") }),
      fmta([[\documentclass[<>]{<>}]], { i(1, "a4paper,12pt"), i(2, "article") }),
    })
  ),

  s(
    { trig = "pkg", name = "Use package" },
    c(1, {
      fmta([[\usepackage{<>}]], { i(1, "package") }),
      fmta([[\usepackage[<>]{<>}]], { i(1, "options"), i(2, "package") }),
    })
  ),

  s(
    { trig = "bd", name = "Begin document" },
    fmta(
      [[
      \begin{document}

      <>

      \end{document}
    ]],
      { v(1) }
    )
  ),

  s({ trig = "scn", name = "Section" }, fmta([[\section{<>}]], { v(1, "title") }), { condition = not in_mathzone }),
  s(
    { trig = "sbn", name = "Subsection" },
    fmta([[\subsection{<>}]], { v(1, "title") }),
    { condition = not in_mathzone }
  ),
  s(
    { trig = "ssn", name = "Subsubsection" },
    fmta([[\subsubsection{<>}]], { v(1, "title") }),
    { condition = not in_mathzone }
  ),

  s(
    { trig = "lab", name = "Label" },
    fmta([[\label{<>:<>}]], {
      c(1, { t("sec"), t("eq"), t("thm"), t("fig"), t("tab"), t("lem"), t("def") }),
      i(2, "name"),
    })
  ),

  s(
    { trig = "crf", name = "Cleveref Cross-reference" },
    fmta([[\cref{<>:<>}]], {
      c(1, { t("sec"), t("eq"), t("thm"), t("fig"), t("tab"), t("lem"), t("def") }),
      i(2, "name"),
    })
  ),
}
