# module MermaidTools 

struct MermaidFile
    body::Vector{UInt8}
    format::MIME
end

function Base.show(io::IO, mime::MIME"application/pdf", file::MermaidFile)
    # TODO
    write(io, file.body)
end

using Base64: base64encode

function Base.show(io::IO, mime::MIME"text/html", file::MermaidFile)
    if file.format isa MIME"image/png"
        # from Plots.jl/src/output.jl
        write(io, "<img src=\"data:image/png;base64,", base64encode(file.body), "\" />")
    elseif file.format isa MIME"application/pdf"
        write(io, "PDF file (", Base.format_bytes(length(file.body)), ")")
    else
        write(io, file.body)
    end
end

# module MermaidTools 
