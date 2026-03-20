local ls = require("luasnip")
local f = ls.function_node
local d = ls.dynamic_node
local r = ls.restore_node

-- Auxiliary functions

-- Math zone context
-- taken from https://ejmastnak.com/

local in_mathzone = function(line_to_cursor)
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1 and not line_to_cursor:match("[{_^]%a*$")
end

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

-- Matrices and cases
-- taken from github.com/evesdropper

local generate_matrix = function(args, snip)
  local rows = tonumber(snip.captures[2])
  local cols = tonumber(snip.captures[3])
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(" & "))
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t({ " \\\\", "" }))
  end
  nodes[#nodes] = t(" \\\\")
  return sn(nil, nodes)
end

local generate_hom_matrix = function(args, snip)
  local rows = tonumber(snip.captures[2])
  local cols = tonumber(snip.captures[3])
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    if j == 1 then
      table.insert(nodes, r(ins_indx, i(1)))
      table.insert(nodes, t("_{11}"))
    else
      table.insert(nodes, rep(1))
      table.insert(nodes, t("_{" .. tostring(j) .. "1}"))
    end
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(" & "))
      table.insert(nodes, rep(1))
      table.insert(nodes, t("_{" .. tostring(j) .. tostring(k) .. "}"))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t({ " \\\\", "" }))
  end
  nodes[#nodes] = t(" \\\\")
  return sn(nil, nodes)
end

local generate_cases = function(args, snip)
  local rows = tonumber(snip.captures[1]) or 2
  local cols = 2
  local nodes = {}
  local ins_indx = 1
  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", sn(1, { t("    \\hfil "), i(1) })))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(" & "))
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    table.insert(nodes, t({ " \\\\", "" }))
  end
  table.remove(nodes, #nodes)
  return sn(nil, nodes)
end

-- Snippets

return {

  -- Math

  -- Math alphabet identifiers

  s({ trig = "mc", name = "Calligraphic math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathcal{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mr", name = "Roman math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathrm{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mb", name = "Bold math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathbf{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "ms", name = "Sans serif math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathsf{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mt", name = "Typewriter math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathtt{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mn", name = "Normal math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathnormal{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mi", name = "Italic math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathit{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mf", name = "Euler Fraktur math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathfrak{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  s({ trig = "mk", name = "Blackboard bold math font", snippetType = "autosnippet" }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("\\mathbb{"),
    d(1, get_visual),
    t("}"),
  }, { condition = in_mathzone }),

  -- Display environments and alignment structures

  s({ trig = "mm", snippetType = "autosnippet" }, fmta([[$<>$]], { i(1) })),

  s(
    { trig = "nn", name = "New equation" },
    c(1, {
      fmta(
        [[
          \begin{equation*}
              <>
          \end{equation*}
        ]],
        { d(1, get_visual) }
      ),
      fmta(
        [[
          \begin{equation}
              <>
          \end{equation}
        ]],
        { d(1, get_visual) }
      ),
    })
  ),

  s(
    { trig = "ml", name = "New multline" },
    c(1, {
      fmta(
        [[
          \begin{multline}
              <>
          \end{multline}
        ]],
        { d(1, get_visual) }
      ),
      fmta(
        [[
          \begin{multline*}
              <>
          \end{multline*}
        ]],
        { d(1, get_visual) }
      ),
    })
  ),

  s({ trig = "gap", name = "Multline gap" }, t("\\setlength\\multlinegap{0pt}")),

  s(
    { trig = "sp", name = "New split" },
    fmta(
      [[
        \begin{split}
            <>
        \end{split}
      ]],
      { d(1, get_visual) }
    )
  ),

  s(
    { trig = "gg", name = "New gather" },
    c(1, {
      fmta(
        [[
          \begin{gather}
              <>
          \end{gather}
        ]],
        { d(1, get_visual) }
      ),
      fmta(
        [[
          \begin{gather*}
              <>
          \end{gather*}
        ]],
        { d(1, get_visual) }
      ),
    })
  ),

  s(
    { trig = "ali", name = "New align" },
    c(1, {
      fmta(
        [[
          \begin{align*}
              <>
          \end{align*}
        ]],
        { d(1, get_visual) }
      ),
      fmta(
        [[
          \begin{align}
              <>
          \end{align}
        ]],
        { d(1, get_visual) }
      ),
    })
  ),

  s(
    { trig = "fal", name = "New falign" },
    c(1, {
      fmta(
        [[
          \begin{falign}
              <>
          \end{falign}
        ]],
        { d(1, get_visual) }
      ),
      fmta(
        [[
          \begin{falign*}
              <>
          \end{falign*}
        ]],
        { d(1, get_visual) }
      ),
    })
  ),

  s(
    { trig = "(%d?)cs", name = "New cases environment", snippetType = "autosnippet", regTrig = true },
    fmta(
      [[
        \begin{cases}
        <>
        \end{cases}
      ]],
      { d(1, generate_cases) }
    ),
    { condition = in_mathzone }
  ),

  s(
    { trig = "br", name = "Display line break", snippetType = "autosnippet" },
    fmta([[\\[<>]<>]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "itr", name = "Short text between lines", snippetType = "autosnippet" },
    fmta([[\intertext{<>}]], { v(1, "text") }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "tx", name = "Text inside display", snippetType = "autosnippet" },
    fmta([[\text{<>}]], { v(1, "text") }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "dib", name = "Display page break", snippetType = "autosnippet" },
    t("\\displaybreak"),
    { condition = in_mathzone }
  ),

  s(
    { trig = "dis", name = "Displaystyle", snippetType = "autosnippet" },
    t("\\displaystyle"),
    { condition = in_mathzone }
  ),

  s({ trig = "ty", name = "Textstyle", snippetType = "autosnippet" }, t("\\textstyle"), { condition = in_mathzone }),

  -- Equation numbering and tags

  s(
    { trig = "ntg", name = "Suppress equation tag", snippetType = "autosnippet" },
    t("\\notag"),
    { condition = in_mathzone }
  ),

  s(
    { trig = "tag", name = "Equation tag", snippetType = "autosnippet" },
    c(1, {
      fmta([[\tag{<>}]], { v(1, "tag") }),
      fmta([[\tag*{<>}]], { v(1, "tag") }),
    }),
    { condition = in_mathzone }
  ),

  s({ trig = "teq", name = "Last number equation" }, t("\\theequation")),

  -- Matrix-like environments

  s(
    { trig = "([bBpvV])(%d+)x(%d+)", name = "New matrix", snippetType = "autosnippet", regTrig = true },
    fmta(
      [[
        \begin{<>}
        <>
        \end{<>}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
        d(1, generate_matrix),
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
      }
    ),
    { condition = in_mathzone }
  ),

  s(
    { trig = "([bBpvV])(%d+)h(%d+)", name = "New homogeneous matrix", snippetType = "autosnippet", regTrig = true },
    fmta(
      [[
        \begin{<>}
        <>
        \end{<>}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
        d(1, generate_hom_matrix),
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
      }
    ),
    { condition = in_mathzone }
  ),

  s(
    { trig = "([bBpvV])gn", name = "New generic matrix", snippetType = "autosnippet", regTrig = true },
    fmta(
      [[
        \begin{<>}
            <>_{11} & <>_{12} & \cdots & <>_{1<>} \\
            <>_{21} & <>_{22} & \cdots & <>_{2<>} \\
            \vdots & \vdots & \ddots & \vdots \\
            <>_{<>1} & <>_{<>2} & \cdots & <>_{<><>} \\
        \end{<>}
      ]],
      {
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
        i(1, "A"),
        rep(1),
        rep(1),
        i(2, "n"), -- Row 1
        rep(1),
        rep(1),
        rep(1),
        rep(2), -- Row 2
        rep(1),
        i(3, "m"),
        rep(1),
        rep(3),
        rep(1),
        rep(3),
        rep(2), -- Row m
        f(function(_, snip)
          return snip.captures[1] .. "matrix"
        end),
      }
    ),
    { condition = in_mathzone }
  ),

  -- Subscripts and Superscripts

  s(
    { trig = "`", name = "Superscript", snippetType = "autosnippet", wordTrig = false },
    fmta([[^{<>}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = ";", name = "Subscript", snippetType = "autosnippet", wordTrig = false },
    fmta([[_{<>}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta([[<>_<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)_(%d)(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta([[<>_{<><><>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
      i(1),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta([[<>_<>]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)_(%d)(%d)", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta([[<>_{<><><>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      f(function(_, snip)
        return snip.captures[2]
      end),
      f(function(_, snip)
        return snip.captures[3]
      end),
      i(1),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "st", name = "Stacking", snippetType = "autosnippet" },
    fmta(
      [[
        \substack{<> \\ <>}
      ]],
      { d(1, get_visual), i(2) }
    ),
    { condition = in_mathzone }
  ),

  -- Compound Structures (Arrows, Fractions, Binomials)
  s(
    { trig = "lxl", name = "Left relation arrow", snippetType = "autosnippet" },
    c(1, {
      fmta([[\xleftarrow{<>}]], { i(1, "top") }),
      fmta([[\xleftarrow[<>]{<>}]], { i(1, "bottom"), i(2, "top") }),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "lxr", name = "Right relation arrow", snippetType = "autosnippet" },
    c(1, {
      fmta([[\xrightarrow{<>}]], { i(1, "top") }),
      fmta([[\xrightarrow[<>]{<>}]], { i(1, "bottom"), i(2, "top") }),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "cf", name = "Continued fraction", snippetType = "autosnippet" },
    c(1, {
      fmta(
        [[
          \cfrac{<>}{
              <>
          }
        ]],
        { i(1, "num"), i(2, "den") }
      ),
      fmta(
        [[
          \cfrac[<>]{<>}{
              <>
          }
        ]],
        { i(1, "align"), i(2, "num"), i(3, "den") }
      ),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "bx", name = "Boxed formula", snippetType = "autosnippet" },
    fmta([[\boxed{<>}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "//", snippetType = "autosnippet", name = "Fraction" },
    fmta([[\frac{<>}{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  -- Auto fractions
  s(
    { trig = "([%w]+)/", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta([[\frac{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)/", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    fmta([[\frac{<>}{<>}]], {
      f(function(_, snip)
        return snip.captures[1]
      end),
      i(1),
    }),
    { condition = in_mathzone }
  ),

  -- Fraction with Choice Node (frac, dfrac, tfrac)
  s(
    { trig = "ff", name = "Fraction Choices", snippetType = "autosnippet" },
    c(1, {
      fmta([[\frac{<>}{<>}]], { i(1), i(2) }),
      fmta([[\dfrac{<>}{<>}]], { i(1), i(2) }),
      fmta([[\tfrac{<>}{<>}]], { i(1), i(2) }),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "bm", name = "Binomial coefficient", snippetType = "autosnippet" },
    c(1, {
      fmta([[\binom{<>}{<>}]], { i(1), i(2) }),
      fmta([[\dbinom{<>}{<>}]], { i(1), i(2) }),
      fmta([[\tbinom{<>}{<>}]], { i(1), i(2) }),
    }),
    { condition = in_mathzone }
  ),

  -- Decorations

  s(
    { trig = "abv", name = "Place material above", snippetType = "autosnippet" },
    fmta([[\overset{<>}{<>}]], { i(1, "above"), v(2, "material") }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "bel", name = "Place material below", snippetType = "autosnippet" },
    fmta([[\underset{<>}{<>}]], { i(1, "below"), v(2, "material") }),
    { condition = in_mathzone }
  ),

  -- Limiting positions
  s(
    { trig = "lmt", name = "Above/below operator", snippetType = "autosnippet" },
    t("\\limits"),
    { condition = in_mathzone }
  ),

  s(
    { trig = "nli", name = "Right of the operator", snippetType = "autosnippet" },
    t("\\nolimits"),
    { condition = in_mathzone }
  ),

  -- Simple Relations & Symbols (Condensed into readable one-liners)
  s(
    { trig = "eq", name = "Congruence relation", snippetType = "autosnippet" },
    t("\\equiv"),
    { condition = in_mathzone }
  ),
  s({ trig = "ne", name = "Not equal", snippetType = "autosnippet" }, t("\\ne"), { condition = in_mathzone }),
  s({ trig = "nr", name = "Relation negation", snippetType = "autosnippet" }, t("\\not"), { condition = in_mathzone }),
  s({ trig = "app", name = "Approx", snippetType = "autosnippet" }, t("\\approx"), { condition = in_mathzone }),
  s({ trig = "le", name = "Less or equal", snippetType = "autosnippet" }, t("\\le"), { condition = in_mathzone }),
  s({ trig = "ge", name = "Greater or equal", snippetType = "autosnippet" }, t("\\ge"), { condition = in_mathzone }),
  s({ trig = "mp", name = "Minus plus", snippetType = "autosnippet" }, t("\\mp"), { condition = in_mathzone }),
  s({ trig = "pm", name = "Plus minus", snippetType = "autosnippet" }, t("\\pm"), { condition = in_mathzone }),
  s({ trig = "tm", name = "Times", snippetType = "autosnippet" }, t("\\times"), { condition = in_mathzone }),
  s({ trig = "cd", name = "Centered dot", snippetType = "autosnippet" }, t("\\cdot"), { condition = in_mathzone }),
  s({ trig = "cir", name = "Circle", snippetType = "autosnippet" }, t("\\circ"), { condition = in_mathzone }),
  s({ trig = "opl", name = "Oplus", snippetType = "autosnippet" }, t("\\oplus"), { condition = in_mathzone }),
  s({ trig = "omt", name = "Otimes", snippetType = "autosnippet" }, t("\\otimes"), { condition = in_mathzone }),
  s({ trig = "dv", name = "Middle bar", snippetType = "autosnippet" }, t("\\mid"), { condition = in_mathzone }),
  s(
    { trig = "ndv", name = "Not divides", snippetType = "autosnippet" },
    t("\\centernot\\mid"),
    { condition = in_mathzone }
  ),
  s({ trig = "imp", name = "Imaginary part", snippetType = "autosnippet" }, t("\\Im"), { condition = in_mathzone }),
  s({ trig = "rpa", name = "Real part", snippetType = "autosnippet" }, t("\\Re"), { condition = in_mathzone }),

  -- Complex Relations with Choices
  s(
    { trig = "cn", name = "Congruent", snippetType = "autosnippet" },
    c(1, { t("\\cong"), t("\\ncong") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "pc", name = "Precedes", snippetType = "autosnippet" },
    c(1, { t("\\prec"), t("\\nprec") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sx", name = "Succedes", snippetType = "autosnippet" },
    c(1, { t("\\succ"), t("\\nsucc") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "re", name = "Relation", snippetType = "autosnippet" },
    c(1, { t("\\sim"), t("\\nsim") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sbg", name = "Left triangle", snippetType = "autosnippet" },
    c(1, { t("\\vartriangleleft"), t("\\ntriangleleft") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sgc", name = "Right triangle", snippetType = "autosnippet" },
    c(1, { t("\\vartriangleright"), t("\\ntriangleright") }),
    { condition = in_mathzone }
  ),

  -- Modular Math
  s(
    { trig = "md", name = "Mod operator", snippetType = "autosnippet" },
    fmta([[\Mod{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "opm", name = "Mod operator", snippetType = "autosnippet" },
    fmta([[<> \bmod <>]], { i(1, "..."), i(2, "...") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "mod", name = "Modular relation choices", snippetType = "autosnippet" },
    c(1, {
      fmta([[<> \equiv <> \pmod{<>}]], { i(1, "a"), i(2, "b"), i(3, "n") }),
      fmta([[<> \not\equiv <> \pmod{<>}]], { i(1, "a"), i(2, "b"), i(3, "n") }),
      fmta([[<> \equiv <> \mod{<>}]], { i(1, "a"), i(2, "b"), i(3, "n") }),
      fmta([[<> \not\equiv <> \mod{<>}]], { i(1, "a"), i(2, "b"), i(3, "n") }),
    }),
    { condition = in_mathzone }
  ),

  -- Math Functions (Trig, Log, Exp, etc.)
  s({ trig = "sin", snippetType = "autosnippet" }, t("\\sin"), { condition = in_mathzone }),
  s({ trig = "cos", snippetType = "autosnippet" }, t("\\cos"), { condition = in_mathzone }),
  s({ trig = "tan", snippetType = "autosnippet" }, t("\\tan"), { condition = in_mathzone }),
  s({ trig = "cot", snippetType = "autosnippet" }, t("\\cot"), { condition = in_mathzone }),
  s({ trig = "sec", snippetType = "autosnippet" }, t("\\sec"), { condition = in_mathzone }),
  s({ trig = "csc", name = "csc", snippetType = "autosnippet" }, t("\\csc"), { condition = in_mathzone }),
  s({ trig = "asin", name = "arcsin", snippetType = "autosnippet" }, t("\\arcsin"), { condition = in_mathzone }),
  s({ trig = "acos", name = "arccos", snippetType = "autosnippet" }, t("\\arccos"), { condition = in_mathzone }),
  s({ trig = "atan", name = "arctan", snippetType = "autosnippet" }, t("\\arctan"), { condition = in_mathzone }),
  s({ trig = "acot", name = "arccot", snippetType = "autosnippet" }, t("\\arccot"), { condition = in_mathzone }),
  s({ trig = "asec", name = "arcsec", snippetType = "autosnippet" }, t("\\arcsec"), { condition = in_mathzone }),
  s({ trig = "acsc", name = "arccsc", snippetType = "autosnippet" }, t("\\arccsc"), { condition = in_mathzone }),
  s({ trig = "sinh", snippetType = "autosnippet" }, t("\\sinh"), { condition = in_mathzone }),
  s({ trig = "cosh", snippetType = "autosnippet" }, t("\\cosh"), { condition = in_mathzone }),
  s({ trig = "tanh", snippetType = "autosnippet" }, t("\\tanh"), { condition = in_mathzone }),
  s({ trig = "coth", snippetType = "autosnippet" }, t("\\coth"), { condition = in_mathzone }),
  s({ trig = "sech", snippetType = "autosnippet" }, t("\\sech"), { condition = in_mathzone }),
  s({ trig = "csch", name = "csch", snippetType = "autosnippet" }, t("\\csch"), { condition = in_mathzone }),
  s({ trig = "asinh", name = "arcsinh", snippetType = "autosnippet" }, t("\\arcsinh"), { condition = in_mathzone }),
  s({ trig = "acosh", name = "arccosh", snippetType = "autosnippet" }, t("\\arccosh"), { condition = in_mathzone }),
  s({ trig = "atanh", name = "arctanh", snippetType = "autosnippet" }, t("\\arctanh"), { condition = in_mathzone }),
  s({ trig = "acoth", name = "arccoth", snippetType = "autosnippet" }, t("\\arccoth"), { condition = in_mathzone }),
  s({ trig = "asech", name = "arcsech", snippetType = "autosnippet" }, t("\\arcsech"), { condition = in_mathzone }),
  s({ trig = "acsch", name = "arccsch", snippetType = "autosnippet" }, t("\\arccsch"), { condition = in_mathzone }),
  s({ trig = "exp", name = "exp", snippetType = "autosnippet" }, t("\\exp"), { condition = in_mathzone }),
  s({ trig = "ln", snippetType = "autosnippet" }, t("\\ln"), { condition = in_mathzone }),
  s({ trig = "log", name = "log", snippetType = "autosnippet" }, t("\\log"), { condition = in_mathzone }),
  s({ trig = "arg", snippetType = "autosnippet" }, t("\\arg"), { condition = in_mathzone }),
  s({ trig = "deg", snippetType = "autosnippet" }, t("\\deg"), { condition = in_mathzone }),
  s({ trig = "det", snippetType = "autosnippet" }, t("\\det"), { condition = in_mathzone }),
  s({ trig = "dim", snippetType = "autosnippet" }, t("\\dim"), { condition = in_mathzone }),
  s({ trig = "gc", name = "gcd", snippetType = "autosnippet" }, t("\\gcd"), { condition = in_mathzone }),
  s({ trig = "hm", name = "hom", snippetType = "autosnippet" }, t("\\hom"), { condition = in_mathzone }),
  s({ trig = "kr", name = "ker", snippetType = "autosnippet" }, t("\\ker"), { condition = in_mathzone }),

  -- Min, Max, Sup, Inf, Lim (With choices for subscript mapping)
  s(
    { trig = "xm", name = "Maximum", snippetType = "autosnippet" },
    c(1, { t("\\max"), fmta([[\max_{<>}]], { i(1, "...") }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "mu", name = "Minimum", snippetType = "autosnippet" },
    c(1, { t("\\min"), fmta([[\min_{<>}]], { i(1, "...") }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "nf", name = "Infimum", snippetType = "autosnippet" },
    c(1, { t("\\inf"), fmta([[\inf_{<>}]], { i(1, "...") }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sr", name = "Supremum", snippetType = "autosnippet" },
    c(1, { t("\\sup"), fmta([[\sup_{<>}]], { i(1, "...") }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "lim", name = "Limit", snippetType = "autosnippet" },
    c(1, { fmta([[\lim_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }), t("\\lim") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "lif", name = "liminf", snippetType = "autosnippet" },
    c(1, { fmta([[\liminf_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }), t("\\liminf") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "lsu", name = "limsup", snippetType = "autosnippet" },
    c(1, { fmta([[\limsup_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }), t("\\limsup") }),
    { condition = in_mathzone }
  ),

  -- Operators with Arguments
  s(
    { trig = "opr", name = "Define new operator" },
    c(1, {
      fmta([[\DeclareMathOperator{<>}{<>}]], { i(1, "\\cmd"), i(2, "text") }),
      fmta([[\DeclareMathOperator*{<>}{<>}]], { i(1, "\\cmd"), i(2, "text") }),
    })
  ),

  s(
    { trig = "ce", name = "Ceiling", snippetType = "autosnippet" },
    c(1, {
      fmta([[\lceil <> \rceil]], { d(1, get_visual) }),
      fmta([[\left\lceil <> \right\rceil]], { d(1, get_visual) }),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "fl", name = "Floor", snippetType = "autosnippet" },
    c(1, {
      fmta([[\lfloor <> \rfloor]], { d(1, get_visual) }),
      fmta([[\left\lfloor <> \right\rfloor]], { d(1, get_visual) }),
    }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "sq", name = "Square root", snippetType = "autosnippet" },
    c(1, {
      fmta([[\sqrt{<>}]], { d(1, get_visual) }),
      fmta([[\sqrt[<>]{<>}]], { i(1, "n"), d(2, get_visual) }),
    }),
    { condition = in_mathzone }
  ),

  -- Bra, Ket, Braket
  s(
    { trig = "ba", name = "Bra", snippetType = "autosnippet" },
    c(1, { fmta([[\bra{<>}]], { i(1) }), fmta([[\bra*{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "kt", name = "Ket", snippetType = "autosnippet" },
    c(1, { fmta([[\ket{<>}]], { i(1) }), fmta([[\ket*{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "bk", name = "Braket", snippetType = "autosnippet" },
    c(1, { fmta([[\braket{<>}{<>}]], { i(1), i(2) }), fmta([[\braket*{<>}{<>}]], { i(1), i(2) }) }),
    { condition = in_mathzone }
  ),

  -- Vector Calculus
  s({ trig = "lap", name = "Laplacian", snippetType = "autosnippet" }, t("\\nabla^2 "), { condition = in_mathzone }),
  s(
    { trig = "div", name = "Divergence", snippetType = "autosnippet" },
    c(1, { fmta([[\nabla\cdot\vv{<>}]], { i(1) }), fmta([[\nabla\cdot\vec{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "cur", name = "Curl", snippetType = "autosnippet" },
    c(1, { fmta([[\nabla\times\vv{<>}]], { i(1) }), fmta([[\nabla\times\vec{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),

  -- Function Definitions
  s(
    { trig = "fn", name = "Function domain and codomain", snippetType = "autosnippet" },
    fmta([[<> : <> \longrightarrow <>]], { i(1, "f"), i(2, "A"), i(3, "B") }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "fd", name = "Function definition" },
    fmta(
      [[
        \begin{align*}
            <> : <> &\longrightarrow <> \\
            <> &\longmapsto <>
        \end{align*}
      ]],
      { i(1, "f"), i(2, "A"), i(3, "B"), i(4, "x"), i(5, "f(x)") }
    )
  ),

  -- Ellipses & Punctuation
  s({ trig = "ld", name = "Lower dots", snippetType = "autosnippet" }, t("\\ldots"), { condition = in_mathzone }),
  s({ trig = "cr", name = "Centered dots", snippetType = "autosnippet" }, t("\\cdots"), { condition = in_mathzone }),
  s({ trig = "vd", name = "Vertical dots", snippetType = "autosnippet" }, t("\\vdots"), { condition = in_mathzone }),
  s({ trig = "gd", name = "Diagonal dots", snippetType = "autosnippet" }, t("\\ddots"), { condition = in_mathzone }),
  s({ trig = "col", name = "Colon", snippetType = "autosnippet" }, t(":"), { condition = in_mathzone }),
  s({ trig = "sem", name = "Semicolon", snippetType = "autosnippet" }, t(";"), { condition = in_mathzone }),

  -- Horizontal Extensions
  s(
    { trig = "ovr", name = "Overline", snippetType = "autosnippet" },
    fmta([[\overline{<>}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "und", name = "Underline", snippetType = "autosnippet" },
    fmta([[\underline{<>}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "ovb", name = "Overbrace", snippetType = "autosnippet" },
    fmta([[\overbrace{<>}^{<>}]], { d(1, get_visual), i(2, "top") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "unb", name = "Underbrace", snippetType = "autosnippet" },
    fmta([[\underbrace{<>}_{<>}]], { d(1, get_visual), i(2, "bottom") }),
    { condition = in_mathzone }
  ),

  -- Delimiters
  s(
    { trig = "dp", name = "Parenthesis", snippetType = "autosnippet" },
    fmta([[\left( <> \right)]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "ds", name = "Brackets", snippetType = "autosnippet" },
    fmta([[\left[ <> \right]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "bb", name = "Braces", snippetType = "autosnippet" },
    fmta([[\{ <> \}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "db", name = "Extensible braces", snippetType = "autosnippet" },
    fmta([[\left\{ <> \right\}]], { d(1, get_visual) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "dk", name = "Angle brackets", snippetType = "autosnippet" },
    c(1, {
      fmta([[\left\langle <> \right\rangle]], { d(1, get_visual) }),
      fmta([[\langle <> \rangle]], { d(1, get_visual) }),
    }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "da", name = "Pipes", snippetType = "autosnippet" },
    c(
      1,
      { fmta([[\left\lvert <> \right\rvert]], { d(1, get_visual) }), fmta([[\lvert <> \rvert]], { d(1, get_visual) }) }
    ),
    { condition = in_mathzone }
  ),
  s(
    { trig = "dn", name = "Double pipes", snippetType = "autosnippet" },
    c(
      1,
      { fmta([[\left\lVert <> \right\rVert]], { d(1, get_visual) }), fmta([[\lVert <> \rVert]], { d(1, get_visual) }) }
    ),
    { condition = in_mathzone }
  ),

  s(
    { trig = "big", name = "Big-d delimiters", snippetType = "autosnippet" },
    c(1, { i(1, "\\big"), i(1, "\\Big"), i(1, "\\bigg"), i(1, "\\Bigg") }),
    { condition = in_mathzone }
  ),

  -- Spacing commands
  s({ trig = "thp", name = "Thin space", snippetType = "autosnippet" }, t("\\,"), { condition = in_mathzone }),
  s({ trig = "mdn", name = "Medium space", snippetType = "autosnippet" }, t("\\:"), { condition = in_mathzone }),
  s({ trig = "tkp", name = "Thick space", snippetType = "autosnippet" }, t("\\;"), { condition = in_mathzone }),
  s({ trig = "enp", name = "Enskip", snippetType = "autosnippet" }, t("\\enskip"), { condition = in_mathzone }),
  s({ trig = "qu", name = "Quad", snippetType = "autosnippet" }, t("\\quad"), { condition = in_mathzone }),
  s({ trig = "qq", name = "Double quad", snippetType = "autosnippet" }, t("\\qquad"), { condition = in_mathzone }),
  s({ trig = "thn", name = "Negative thin space", snippetType = "autosnippet" }, t("\\!"), { condition = in_mathzone }),
  s(
    { trig = "hs", name = "Horizontal space", snippetType = "autosnippet" },
    fmta([[\hspace{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "vs", name = "Vertical space", snippetType = "autosnippet" },
    fmta([[\vspace{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),

  -- Greek alphabet

  s({ trig = ".a", snippetType = "autosnippet", wordTrig = false }, t("\\alpha"), { condition = in_mathzone }),
  s({ trig = ".b", snippetType = "autosnippet", wordTrig = false }, t("\\beta"), { condition = in_mathzone }),
  s({ trig = ".c", snippetType = "autosnippet", wordTrig = false }, t("\\chi"), { condition = in_mathzone }),
  s({ trig = ".d", snippetType = "autosnippet", wordTrig = false }, t("\\delta"), { condition = in_mathzone }),
  s({ trig = ".e", snippetType = "autosnippet", wordTrig = false }, t("\\varepsilon"), { condition = in_mathzone }),
  s({ trig = ".g", snippetType = "autosnippet", wordTrig = false }, t("\\gamma"), { condition = in_mathzone }),
  s({ trig = ".h", snippetType = "autosnippet", wordTrig = false }, t("\\eta"), { condition = in_mathzone }),
  s({ trig = ".i", snippetType = "autosnippet", wordTrig = false }, t("\\iota"), { condition = in_mathzone }),
  s({ trig = ".k", snippetType = "autosnippet", wordTrig = false }, t("\\kappa"), { condition = in_mathzone }),
  s({ trig = ".l", snippetType = "autosnippet", wordTrig = false }, t("\\lambda"), { condition = in_mathzone }),
  s({ trig = ".m", snippetType = "autosnippet", wordTrig = false }, t("\\mu"), { condition = in_mathzone }),
  s({ trig = ".n", snippetType = "autosnippet", wordTrig = false }, t("\\nu"), { condition = in_mathzone }),
  s({ trig = ".o", snippetType = "autosnippet", wordTrig = false }, t("\\omega"), { condition = in_mathzone }),
  s({ trig = ".ph", snippetType = "autosnippet", wordTrig = false }, t("\\varphi"), { condition = in_mathzone }),
  s({ trig = ".pi", snippetType = "autosnippet", wordTrig = false }, t("\\pi"), { condition = in_mathzone }),
  s({ trig = ".ps", snippetType = "autosnippet", wordTrig = false }, t("\\psi"), { condition = in_mathzone }),
  s({ trig = ".r", snippetType = "autosnippet", wordTrig = false }, t("\\rho"), { condition = in_mathzone }),
  s({ trig = ".s", snippetType = "autosnippet", wordTrig = false }, t("\\sigma"), { condition = in_mathzone }),
  s({ trig = ".ta", snippetType = "autosnippet", wordTrig = false }, t("\\tau"), { condition = in_mathzone }),
  s({ trig = ".th", snippetType = "autosnippet", wordTrig = false }, t("\\theta"), { condition = in_mathzone }),
  s({ trig = ".u", snippetType = "autosnippet", wordTrig = false }, t("\\upsilon"), { condition = in_mathzone }),
  s({ trig = ".x", snippetType = "autosnippet", wordTrig = false }, t("\\xi"), { condition = in_mathzone }),
  s({ trig = ".z", snippetType = "autosnippet", wordTrig = false }, t("\\zeta"), { condition = in_mathzone }),

  -- Capital Greek
  s({ trig = ".D", snippetType = "autosnippet", wordTrig = false }, t("\\Delta"), { condition = in_mathzone }),
  s({ trig = ".G", snippetType = "autosnippet", wordTrig = false }, t("\\Gamma"), { condition = in_mathzone }),
  s({ trig = ".L", snippetType = "autosnippet", wordTrig = false }, t("\\Lambda"), { condition = in_mathzone }),
  s({ trig = ".O", snippetType = "autosnippet", wordTrig = false }, t("\\Omega"), { condition = in_mathzone }),
  s({ trig = ".Ph", snippetType = "autosnippet", wordTrig = false }, t("\\Phi"), { condition = in_mathzone }),
  s({ trig = ".Pi", snippetType = "autosnippet", wordTrig = false }, t("\\Pi"), { condition = in_mathzone }),
  s({ trig = ".Ps", snippetType = "autosnippet", wordTrig = false }, t("\\Psi"), { condition = in_mathzone }),
  s({ trig = ".S", snippetType = "autosnippet", wordTrig = false }, t("\\Sigma"), { condition = in_mathzone }),
  s({ trig = ".Th", snippetType = "autosnippet", wordTrig = false }, t("\\Theta"), { condition = in_mathzone }),
  s({ trig = ".U", snippetType = "autosnippet", wordTrig = false }, t("\\Upsilon"), { condition = in_mathzone }),
  s({ trig = ".X", snippetType = "autosnippet", wordTrig = false }, t("\\Xi"), { condition = in_mathzone }),

  -- Letter-shaped symbols
  s({ trig = "ha", name = "Aleph", snippetType = "autosnippet" }, t("\\aleph"), { condition = in_mathzone }),
  s({ trig = "hb", name = "Beth", snippetType = "autosnippet" }, t("\\beth"), { condition = in_mathzone }),
  s({ trig = "hd", name = "Daleth", snippetType = "autosnippet" }, t("\\daleth"), { condition = in_mathzone }),
  s({ trig = "hg", name = "Gimel", snippetType = "autosnippet" }, t("\\gimel"), { condition = in_mathzone }),
  s({ trig = "ll", name = "ell", snippetType = "autosnippet" }, t("\\ell"), { condition = in_mathzone }),
  s(
    { trig = "cm", name = "Set complement", snippetType = "autosnippet" },
    t("\\complement"),
    { condition = in_mathzone }
  ),
  s({ trig = "hr", name = "hbar", snippetType = "autosnippet" }, t("\\hbar"), { condition = in_mathzone }),
  s({ trig = "hl", name = "hslash", snippetType = "autosnippet" }, t("\\hslash"), { condition = in_mathzone }),
  s({ trig = "pt", name = "Partial", snippetType = "autosnippet" }, t("\\partial"), { condition = in_mathzone }),

  s({ trig = "dl", name = "Dollar sign", snippetType = "autosnippet" }, t("\\$"), { condition = in_mathzone }),
  s({ trig = "hh", name = "Numeral", snippetType = "autosnippet" }, t("\\#"), { condition = in_mathzone }),
  s({ trig = "fy", name = "Infinity", snippetType = "autosnippet" }, t("\\infty"), { condition = in_mathzone }),
  s({ trig = "pr", name = "Prime", snippetType = "autosnippet" }, t("\\prime"), { condition = in_mathzone }),
  s({ trig = "per", name = "Percentage", snippetType = "autosnippet" }, t("\\%"), { condition = in_mathzone }),
  s({ trig = "amp", name = "Ampersand", snippetType = "autosnippet" }, t("\\&"), { condition = in_mathzone }),
  s({ trig = "ang", name = "Angle", snippetType = "autosnippet" }, t("\\angle"), { condition = in_mathzone }),
  s({ trig = "nb", name = "Nabla", snippetType = "autosnippet" }, t("\\nabla"), { condition = in_mathzone }),
  s({ trig = "ch", name = "Section symbol", snippetType = "autosnippet" }, t("\\S"), { contidion = in_mathzone }),

  -- accents

  s(
    { trig = "(%a)bar", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta([[\overline{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)hat", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta([[\hat{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)vec", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta([[\vec{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)til", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta([[\tilde{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)dot", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta([[\dot{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(%a)ddot", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 100 },
    fmta([[\ddot{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  -- greek accents
  s(
    { trig = "(\\%a+)bar", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta([[\overline{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)hat", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta([[\hat{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)vec", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta([[\vec{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)til", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta([[\tilde{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)dot", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta([[\dot{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "(\\%a+)ddot", regTrig = true, wordTrig = false, snippetType = "autosnippet", priority = 2000 },
    fmta([[\ddot{<>}]], { f(function(_, snip)
      return snip.captures[1]
    end) }),
    { condition = in_mathzone }
  ),

  -- Logic

  s({ trig = "fa", name = "For all", snippetType = "autosnippet" }, t("\\forall"), { condition = in_mathzone }),
  s({ trig = "ex", name = "Exists", snippetType = "autosnippet" }, t("\\exists"), { condition = in_mathzone }),
  s({ trig = "nx", name = "Not exist", snippetType = "autosnippet" }, t("\\nexists"), { condition = in_mathzone }),
  s({ trig = "lt", name = "Logic negation", snippetType = "autosnippet" }, t("\\lnot"), { condition = in_mathzone }),
  s({ trig = "lan", name = "Logic and", snippetType = "autosnippet" }, t("\\land"), { condition = in_mathzone }),
  s({ trig = "lor", name = "Logic or", snippetType = "autosnippet" }, t("\\lor"), { condition = in_mathzone }),
  s({ trig = "ip", name = "Implies", snippetType = "autosnippet" }, t("\\implies"), { condition = in_mathzone }),
  s({ trig = "ib", name = "Implied by", snippetType = "autosnippet" }, t("\\impliedby"), { condition = in_mathzone }),
  s({ trig = "iff", name = "If and only if", snippetType = "autosnippet" }, t("\\iff"), { condition = in_mathzone }),

  s({ trig = "in", name = "Belongs to", snippetType = "autosnippet" }, t("\\in"), { condition = in_mathzone }),
  s({ trig = "ntn", name = "Not in", snippetType = "autosnippet" }, t("\\notin"), { condition = in_mathzone }),
  s({ trig = "na", name = "Owns", snippetType = "autosnippet" }, t("\\ni"), { condition = in_mathzone }),
  s(
    { trig = "vc", name = "Empty set", snippetType = "autosnippet" },
    c(1, { t("\\emptyset"), t("\\varnothing") }),
    { condition = in_mathzone }
  ),
  s({ trig = "nun", name = "Union", snippetType = "autosnippet" }, t("\\cup"), { condition = in_mathzone }),
  s({ trig = "bun", name = "Big union", snippetType = "autosnippet" }, t("\\bigcup"), { condition = in_mathzone }),
  s(
    { trig = "sun", name = "Big subscript union", snippetType = "autosnippet" },
    fmta([[\bigcup_{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "dun", name = "Big definite union", snippetType = "autosnippet" },
    fmta([[\bigcup_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s({ trig = "nit", name = "Intersection", snippetType = "autosnippet" }, t("\\cap"), { condition = in_mathzone }),
  s(
    { trig = "bit", name = "Big intersection", snippetType = "autosnippet" },
    t("\\bigcap"),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sit", name = "Big subscript intersection", snippetType = "autosnippet" },
    fmta([[\bigcap_{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "dit", name = "Big definite intersection", snippetType = "autosnippet" },
    fmta([[\bigcap_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sf", name = "Set difference", snippetType = "autosnippet" },
    t("\\setminus"),
    { condition = in_mathzone }
  ),
  s({ trig = "sbs", name = "Subset", snippetType = "autosnippet" }, t("\\subset"), { condition = in_mathzone }),
  s(
    { trig = "sbq", name = "Subset or equals", snippetType = "autosnippet" },
    c(1, { t("\\subseteq"), t("\\nsubseteq") }),
    { condition = in_mathzone }
  ),
  s({ trig = "sus", name = "Contains", snippetType = "autosnippet" }, t("\\supset"), { condition = in_mathzone }),
  s(
    { trig = "suq", name = "Contains or equals", snippetType = "autosnippet" },
    c(1, { t("\\supseteq"), t("\\nsupseteq") }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "setb", name = "Bar set", snippetType = "autosnippet" },
    fmta([[\{ <> \mid <> \}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  s(
    { trig = "setd", name = "Dots set", snippetType = "autosnippet" },
    fmta([[\{ <> : <> \}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  -- Arrows

  s(
    { trig = "rar", name = "Long right arrow", snippetType = "autosnippet" },
    t("\\longrightarrow"),
    { condition = in_mathzone }
  ),
  s(
    { trig = "lar", name = "Long left arrow", snippetType = "autosnippet" },
    t("\\longleftarrow"),
    { condition = in_mathzone }
  ),
  s(
    { trig = "to", name = "Long maps to", snippetType = "autosnippet" },
    t("\\longmapsto"),
    { condition = in_mathzone }
  ),

  -- Sum

  s(
    { trig = "sm", name = "Subscript sum", snippetType = "autosnippet" },
    c(1, { fmta([[\sum_{<>}]], { i(1) }), t("\\sum") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "ss", name = "Definite sum", snippetType = "autosnippet" },
    fmta([[\sum_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sos", name = "Subscript o-sum", snippetType = "autosnippet" },
    fmta([[\bigoplus_{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "nos", name = "Definite o-sum", snippetType = "autosnippet" },
    fmta([[\bigoplus_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  -- Products

  s(
    { trig = "sp", name = "Subscript product", snippetType = "autosnippet" },
    c(1, { fmta([[\prod_{<>}]], { i(1) }), t("\\prod") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "pp", name = "Definite product", snippetType = "autosnippet" },
    fmta([[\prod_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "sop", name = "Subscript o-product", snippetType = "autosnippet" },
    fmta([[\bigotimes_{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "nop", name = "Definite o-product", snippetType = "autosnippet" },
    fmta([[\bigotimes_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  -- Derivatives

  s(
    { trig = "dd([A-Za-z])", name = "Derivative", regTrig = true, snippetType = "autosnippet" },
    fmta([[\frac{d}{d<>} <>]], { f(function(_, snip)
      return snip.captures[1]
    end), i(1, "f(x)") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "df", name = "Differential", snippetType = "autosnippet" },
    fmta([[\frac{d<>}{d<>}]], { i(1), i(2, "x") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "ndr", name = "n-th derivative", snippetType = "autosnippet" },
    fmta([[\frac{d^{<>}}{d<>^{<>}} <>]], { i(1, "n"), i(2, "x"), rep(1), i(3, "f(x)") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "pdr", name = "Partial derivative", snippetType = "autosnippet" },
    fmta([[\frac{\partial}{\partial <>} <>]], { i(1, "x"), i(2, "f") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "npd", name = "n-th partial derivative", snippetType = "autosnippet" },
    fmta([[\frac{\partial^{<>}}{\partial <>^{<>}} <>]], { i(1, "n"), i(2, "x"), rep(1), i(3, "f") }),
    { condition = in_mathzone }
  ),

  -- Integrals

  s(
    { trig = "itn", name = "Integral", snippetType = "autosnippet" },
    c(1, { t("\\int"), t("\\oint") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "its", name = "Subscript integral", snippetType = "autosnippet" },
    c(1, { fmta([[\int_{<>}]], { i(1) }), fmta([[\oint_{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itd", name = "Definite integral", snippetType = "autosnippet" },
    fmta([[\int_{<>}^{<>}]], { i(1), i(2) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itbn", name = "Double integral", snippetType = "autosnippet" },
    c(1, { t("\\iint"), t("\\oiint") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itbs", name = "Double integral subscript", snippetType = "autosnippet" },
    c(1, { fmta([[\iint_{<>}]], { i(1) }), fmta([[\oiint_{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "ittn", name = "Triple integral", snippetType = "autosnippet" },
    c(1, { t("\\iiint"), t("\\oiiint") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itts", name = "Triple integral subscript", snippetType = "autosnippet" },
    c(1, { fmta([[\iiint_{<>}]], { i(1) }), fmta([[\oiiint_{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itqn", name = "Quadruple integral", snippetType = "autosnippet" },
    c(1, { t("\\iiiint"), t("\\oiiiint") }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itqs", name = "Quadruple integral subscript", snippetType = "autosnippet" },
    c(1, { fmta([[\iiiint_{<>}]], { i(1) }), fmta([[\oiiiint_{<>}]], { i(1) }) }),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itmn", name = "Multiple integral", snippetType = "autosnippet" },
    t("\\idotsint"),
    { condition = in_mathzone }
  ),
  s(
    { trig = "itms", name = "Multiple integral subscript", snippetType = "autosnippet" },
    fmta([[\idotsint_{<>}]], { i(1) }),
    { condition = in_mathzone }
  ),
}
