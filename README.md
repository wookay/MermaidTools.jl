# MermaidTools 🧜

[![CI](https://github.com/wookay/MermaidTools.jl/actions/workflows/actions.yml/badge.svg)](https://github.com/wookay/MermaidTools.jl/actions/workflows/actions.yml)

```julia
julia> using MermaidTools

julia> input = """
       timeline
       title History of Social Media Platform
       2002 : LinkedIn
       2004 : Facebook
            : Google
       2005 : Youtube
       2006 : Twitter
       """
"timeline\ntitle History of Social Media Platform\n2002 : LinkedIn\n2004 : Facebook\n     : Google\n2005 : Youtube\n2006 : Twitter\n"

julia> mmdc(input, "svg")
MermaidFile(UInt8[0x3c, 0x73, 0x76, 0x67, 0x20, 0x61, 0x72, 0x69, 0x61, 0x2d  …  0x3c, 0x2f, 0x67, 0x3e, 0x3c, 0x2f, 0x73, 0x76, 0x67, 0x3e], MIME type text/svg)

julia> mmdc(input, "png")
MermaidFile(UInt8[0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00  …  0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82], MIME type image/png)
```

* [Pluto notebook example](docs/pluto/note_MermaidTools.jl)
![timeline](https://raw.github.com/wookay/MermaidTools.jl/main/test/mermaidtools/history.png)

### Requirements
* Julia  https://julialang.org/
* mermaid-cli  https://github.com/mermaid-js/mermaid-cli
