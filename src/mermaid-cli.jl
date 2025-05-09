# module MermaidTools

function mmdc(io::IO, input::String, outputFormat::String,
                                     theme::String,
                                     backgroundColor::String,
                                     width::Int,
                                     height::Int,
                                     svgId::String,
                                     puppeteerConfigFile::Union{Nothing, String},
                                     configFile::Union{Nothing, String},
                                     cssFile::Union{Nothing, String},
                                     err_io::IO)
    oldstderr = stderr
    err_pipe = Pipe()
    redirect_stderr(err_pipe)

    mmdc_args = [
        "--input", "-",
        "--output", "-",
        "--outputFormat", outputFormat,
        "--theme", theme,
        "--backgroundColor", backgroundColor,
        "--width", string(width),
        "--height", string(height),
        "--svgId", svgId,
    ]
    puppeteerConfigFile isa String && push!(mmdc_args, "--puppeteerConfigFile", puppeteerConfigFile)
    configFile          isa String && push!(mmdc_args, "--configFile", configFile)
    cssFile             isa String && push!(mmdc_args, "--cssFile", cssFile)
    mmdc_cmd::Cmd = Cmd(["mmdc", mmdc_args...])
    pipe::IO = open(mmdc_cmd, "r+")
    t::Task = @async begin
        write(pipe, input)
        close(pipe.in)
    end

    while !eof(pipe)
        write(io, read(pipe, UInt8))
    end
    wait(t)
    close(pipe)

    redirect_stderr(oldstderr)
    close(err_pipe.in)

    write(err_io, read(err_pipe.out, String))
    close(err_pipe.out)
end

function mmdc(input::String; outputFormat::String = "svg",
                             theme::String = "default",
                             backgroundColor::String = "white",
                             width::Int = 800,
                             height::Int = 600,
                             svgId::String = string("svg-", hash(rand())),
                             puppeteerConfigFile::Union{Nothing, String} =
                                 ifelse(haskey(ENV, "CI"), normpath(@__DIR__, "puppeteer-config.json"), nothing),
                             configFile::Union{Nothing, String} = nothing,
                             cssFile::Union{Nothing, String} = nothing,
                             err_io::IO = stderr)::Union{Nothing, MermaidFile}
    try
        success(`mmdc --version`)
    catch ex
        @error ex
        return nothing
    end
    io = IOBuffer()
    mmdc(io, input, outputFormat, theme, backgroundColor, width, height, svgId, puppeteerConfigFile, configFile, cssFile, err_io)
    if outputFormat == "png"
        format = MIME("image/png")
    elseif outputFormat == "pdf"
        format = MIME("application/pdf")
    else
        format = MIME("text/svg")
    end
    return MermaidFile(take!(io), format)
end

# module MermaidTools
