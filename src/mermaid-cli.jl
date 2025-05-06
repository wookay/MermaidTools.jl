# module MermaidTools

function mmdc(input::String, err_io::IO, io::IO, mime::MIME"text/svg")
    oldstderr = stderr
    err_pipe = Pipe()
    redirect_stderr(err_pipe)

    mmdc_cmd::Cmd = `mmdc --input -  --output -  --outputFormat svg`
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

    write(err_io, read(err_pipe, String))
    close(err_pipe.out)
end

function mmdc(input::String; err_io::IO = stderr)::Union{Nothing, String}
    output = nothing
    try
        success(`mmdc --version`)
        io = IOBuffer()
        mmdc(input, err_io, io, MIME"text/svg"())
        seekstart(io)
        output = read(io, String)
    catch ex
        @error ex
    end
    output
end

# module MermaidTools
