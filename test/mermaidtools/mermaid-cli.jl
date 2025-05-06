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
output = mmdc(input)
@test startswith(output, """<svg aria-roledescription="timeline" """)

end # module test_mermaidtools_mermaidcli
