function get_idxval(a::AbstractString)
    a = replace(a, "[", "")
    a = replace(a, "]", "")
    a = replace(a, "=", ",")
    a = replace(a, " ", "")
    a1, a2, a3 = split(a, ",")
    a1, a2 = parse(Int, a1), parse(Int, a2)
    a3 = eval(parse(a3))

    return a1, a2, a3
end
function make_sparse_matrix(A, sizear::Tuple)
    A = split(A, "\n")
    A = A[2:end]
    n = length(A)
    ar = spzeros(Complex128, sizear...)
    for i in 1:n
        row, col, val = get_idxval(A[i])
        ar[row,col] = val
    end

    return ar
end

srand(2018)
niter = 100
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{Vector{Complex128}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i])
    end
    A = sprint((io, data) -> Base.showarray(IOContext(io, :limit => true), data, true, header=true), kron(x...))
    B = sprint((io, data) -> showarray_std(IOContext(io, :limit => true), data, l, true, header=true), kron(reverse(x)...))
    @test A == B
end
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{Vector{Complex128}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i])
    end
    A = sprint((io, data) -> Base.showarray(IOContext(io, :limit => true), data, true, header=false), kron(x...))
    B = sprint((io, data) -> showarray_std(IOContext(io, :limit => true), data, l, true, header=false), kron(reverse(x)...))
    @test A == B
end
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{Vector{Complex128}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i])
    end
    A = sprint((io, data) -> Base.showarray(IOContext(io, :limit => false), data, false, header=true), kron(x...))
    B = sprint((io, data) -> showarray_std(IOContext(io, :limit => false), data, l, false, header=true), kron(reverse(x)...))
    @test A == B
end
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{Vector{Complex128}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i])
    end
    A = sprint((io, data) -> Base.showarray(IOContext(io, :limit => false), data, false, header=false), kron(x...))
    B = sprint((io, data) -> showarray_std(IOContext(io, :limit => false), data, l, false, header=false), kron(reverse(x)...))
    @test A == B
end
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{Matrix{Complex128}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i], l[i])
    end
    A = sprint((io, data) -> Base.showarray(IOContext(io, :limit => true), data, false, header=true), kron(x...))
    B = sprint((io, data) -> showarray_std(IOContext(io, :limit => true), data, l, l, false, header=true), kron(reverse(x)...))
    @test A == B
end
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{Matrix{Complex128}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i], l[i])
    end
    A = sprint((io, data) -> Base.showarray(IOContext(io, :limit => false), data, true, header=true), kron(x...))
    B = sprint((io, data) -> showarray_std(IOContext(io, :limit => false), data, l, l, true, header=true), kron(reverse(x)...))
    @test A == B
end
for i in 1:niter
    n = rand(2:4)
    l = rand(2:4, n)
    x = Vector{SparseMatrixCSC{Complex{Float64},Int64}}(n)
    for i in 1:n
        x[i] = rand(Complex128, l[i], l[i]) * 20
        x[i][bitrand(l[i], l[i])] = 0
        x[i] = x[i] |> full |> sparse
    end
    A = sprint((io, data) -> Base.show(IOContext(io, :limit => false), data), kron(x...))
    B = sprint((io, data) -> showsparsearray_std(IOContext(io, :limit => false), data, l, l), kron(reverse(x)...))
    @test make_sparse_matrix(A, size(kron(x...))) == make_sparse_matrix(B, size(kron(x...)))
end
