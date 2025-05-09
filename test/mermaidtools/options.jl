module test_mermaidtools_options

using Test
using MermaidTools

timeline = """
timeline
title History of Social Media Platform
2002 : LinkedIn
2004 : Facebook
     : Google
2005 : Youtube
2006 : Twitter
"""

svg_expr = :( mmdc(timeline, outputFormat = "svg",
                             theme = "default",
                             backgroundColor = "white",
                             width = 800,
                             height = 600,
                             svgId = "svgId",
                  )
            )
svg_file = @time string(svg_expr) Core.eval(@__MODULE__, svg_expr)
svg_filename = normpath(@__DIR__, "history_options.svg")
# write(svg_filename, svg_file.body)
@test String(svg_file.body[1:37]) == """<svg aria-roledescription="timeline" """

end # module test_mermaidtools_options
