# module MermaidTools

function mmdc(input::String, err_io::IO, io::IO, outputFormat::String)
    oldstderr = stderr
    err_pipe = Pipe()
    redirect_stderr(err_pipe)

    mmdc_args = [
        "--input", "-",
        "--output", "-",
        "--outputFormat", outputFormat,
    ]
    if haskey(ENV, "CI")
        puppeteerConfigFile = normpath(@__DIR__, "puppeteer-config.json")
        push!(mmdc_args, "--puppeteerConfigFile", puppeteerConfigFile)
    end
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

function mmdc(input::String, outputFormat::String; err_io::IO = stderr)::Union{Nothing, MermaidFile}
    try
        success(`mmdc --version`)
    catch ex
        @error ex
        return nothing
    end
    io = IOBuffer()
    mmdc(input, err_io, io, outputFormat)
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
