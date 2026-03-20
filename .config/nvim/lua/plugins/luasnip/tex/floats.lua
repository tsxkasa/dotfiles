return {
  s(
    { trig = "fig", name = "Figure environment" },
    fmta(
      [[
      \begin{figure}[<>]
          \centering
          \includegraphics[width=<>\linewidth]{<>}
          \caption{<>}
          \label{fig:<>}
      \end{figure}
    ]],
      { i(1, "htpb"), i(2, "0.8"), i(3, "image_path"), i(4, "caption"), i(5, "label") }
    )
  ),

  s(
    { trig = "tab", name = "Table environment" },
    fmta(
      [[
      \begin{table}[<>]
          \centering
          \begin{tabular}{<>}
              <>
          \end{tabular}
          \caption{<>}
          \label{tab:<>}
      \end{table}
    ]],
      { i(1, "htpb"), i(2, "c c c"), i(3), i(4, "caption"), i(5, "label") }
    )
  ),

  s(
    { trig = "rr", name = "Array environment" },
    fmta(
      [[
      \begin{array}{<>}
          <>
      \end{array}
    ]],
      { i(1, "c c"), i(2) }
    )
  ),

  s({ trig = "he", name = "Break line height" }, fmta([[\\[<>]], { i(1, "1ex") })),
  s({ trig = "hn", name = "Horizontal line" }, t("\\hline")),
}
