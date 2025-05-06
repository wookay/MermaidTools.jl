module test_mermaidtools_mermaidcli

using Test
using MermaidTools

input = """
timeline
title History of Social Media Platform
2002 : LinkedIn
2004 : Facebook
     : Google
2005 : Youtube
2006 : Twitter
"""

expr = :( mmdc(input, "svg") )
output = @time string(expr) Core.eval(@__MODULE__, expr)
@test startswith(output, """<svg aria-roledescription="timeline" """)

expr = :( mmdc(input, "png") )
output = @time string(expr) Core.eval(@__MODULE__, expr)
@test output[1:5] == [0x89, 0x50, 0x4e, 0x47, 0x0d]

history_filename = normpath(@__DIR__, "history.png")
expr = :( read(history_filename) )
history_png = @time "read(\"history.png\")" Core.eval(@__MODULE__, expr)
if haskey(ENV, "CI")
    @test history_png != output
else
    @test history_png == output
end

end # module test_mermaidtools_mermaidcli
