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

### svg

expr = :( mmdc(input, "svg") )

# 1st run
file = @time string(expr) Core.eval(@__MODULE__, expr)

# 2nd run
file = @time string(expr) Core.eval(@__MODULE__, expr)

@test file.format == MIME("text/svg")
@test String(file.body[1:37]) == """<svg aria-roledescription="timeline" """

using Jive # sprint_html
@test sprint_html(file)[1:37] == """<svg aria-roledescription="timeline" """


### png

png_expr = :( mmdc(input, "png") )
png_file = @time string(png_expr) Core.eval(@__MODULE__, png_expr)
@test png_file.format == MIME("image/png")
@test png_file.body[1:5] == [0x89, 0x50, 0x4e, 0x47, 0x0d]

history_png_filename = normpath(@__DIR__, "history.png")
# write(history_png_filename, png_file.body)

read_png_expr = :( read(history_png_filename) )
history_png_data = @time "read(\"history.png\")" Core.eval(@__MODULE__, read_png_expr)


### pdf

pdf_expr = :( mmdc(input, "pdf") )
pdf_file = @time string(pdf_expr) Core.eval(@__MODULE__, pdf_expr)
@test pdf_file.format == MIME("application/pdf")

history_pdf_filename = normpath(@__DIR__, "history.pdf")
# write(history_pdf_filename, pdf_file.body)

read_pdf_expr = :( read(history_pdf_filename) )
history_pdf_data = @time "read(\"history.pdf\")" Core.eval(@__MODULE__, read_pdf_expr)


if haskey(ENV, "CI")
    @test history_png_data != png_file.body
    @test history_pdf_data != pdf_file.body
else
    @test history_png_data == png_file.body
    @test history_pdf_data == pdf_file.body
end

end # module test_mermaidtools_mermaidcli
