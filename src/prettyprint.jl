import LinearAlgebra: Adjoint, Transpose
import SparseArrays: SparseMatrixCSC
import Base.Grisu: _show
export dirac

const SHORTEST = 1
const FIXED = 2
const PRECISION = 3


"""
    set_properties
"""
function set_properties(; precision::Int=_precision,
                          islatex::Bool=_islatex,
                          displayall::Bool=_displayall,
                          numhead::Int=_numhead,
                          newline::Bool=_newline)
    global _precision = precision
    global _islatex = islatex
    global _displayall = displayall
    global _numhead = numhead
    global _newline = newline
    nothing
end
# set_properties(precision=0, islatex=true, displayall)
const PureState = Union{Vector, Adjoint{T,Vector{T}}, Transpose{T,Vector{T}}} where T
const MixedState =  Union{Matrix, SparseMatrixCSC, Adjoint{T,Matrix{T}}, Transpose{T,Matrix{T}}} where T

function reset_properties()
    set_properties(precision=0, islatex=true, displayall=true, numhead=5, newline=false)
end
reset_properties()

"""
    dirac
"""
function dirac(io::IO, state::PureState, dims::Vector{Int}, statename::String="ψ")
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited # for IJulia rendering
        if statename == "ψ"
            statename = "\\psi"
        end
        str = "\$" * sprint(io -> print_dirac(io, state, dims, statename)) * "\$"
        display("text/markdown", str)
    else
        print_dirac(io, state, dims, statename)
    end
end
dirac(state::PureState, dims::Vector{Int}, statename::String="ψ") = dirac(stdout, state, dims, statename)
function dirac(io::IO, state::PureState, statename::String="ψ")
    n = log2(length(state))
    @assert isinteger(n)
    dims = fill(2, (Int(n), ))
    dirac(io, state, dims, statename)
end
dirac(state::PureState, statename::String="ψ") = dirac(stdout, state, statename)

function dirac(io::IO, state::MixedState, ldims::Vector{Int}, rdims::Vector{Int}, statename::String="ρ")
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited # for IJulia rendering
        if statename == "ρ"
            statename = "\\hat{\\rho}"
        end
        str = "\$" * sprint(io -> print_dirac(io, state, ldims, rdims, statename)) * "\$"
        display("text/markdown", str)
    else
        print_dirac(io, state, ldims, rdims, statename)
    end
end
dirac(state::MixedState, ldims::Vector{Int}, rdims::Vector{Int}, statename::String="ρ") = dirac(stdout, state, ldims, rdims, statename)
dirac(state::MixedState, dims::Vector{Int}, statename::String="ρ") = dirac(stdout, state, dims, dims, statename)
function dirac(io::IO, state::MixedState, statename::String="ρ")
    row, col = size(state)
    n, m = log2(row), log2(col)
    @assert isinteger(n) || isinteger(m)
    ldims, rdims = fill(2, (Int(n), )), fill(2, (Int(m), ))
    dirac(io, state, ldims, rdims, statename)
end
dirac(state::MixedState, statename::String="ρ") = dirac(stdout, state, statename)

"""
    print_dirac(io::IO, state::PureState, dims::Vector{Int}, statename::String="ψ")
    print_dirac(io::IO, state::MixedState,
                        ldims::Vector{Int},
                        rdims::Vector{Int},
                        statename::String="ρ") where T <: Number
"""
function print_dirac(io::IO, state::PureState, dims::Vector{Int}, statename::String="ψ")
    io, braket = IO_braket(io, state)

    isfirstterm = true
    s = "$(braket[1])$(statename)$(braket[2]) = "
    print(io, s)
    num_term = 0
    for (idx, ent) in enumerate(state)
        num_term += 1
        iszero(ent) && continue
        if ent ≈ one(ent)
            ent = one(ent)
        end

        print_dirac_term(io, idx, ent, dims, isfirstterm)

        if isfirstterm
            isfirstterm = false
        end

        if !_displayall && num_term >= _numhead
            break
        end
        _newline && print(io, "\n", repeat(" ", length(s)-1))
    end
    num_term < length(state) && return println(io, " +...")
    !_newline && println(io)
    return nothing
end
function print_dirac(io::IO, state::MixedState,
                             ldims::Vector{Int},
                             rdims::Vector{Int},
                             statename::String="ρ") where T <: Number
    nrow, ncol = size(state)
    @assert nrow == prod(ldims) && ncol == prod(rdims)
    io, braket = IO_braket(io, state)

    isfirstterm = true
    print(io, statename, " = ")
    num_term = 0
    exitloop = false
    for row in 1:nrow
        for col in 1:ncol
            num_term += 1
            ent = state[row,col]
            iszero(ent) && continue
            if ent ≈ one(ent)
                ent = one(ent)
            end
            print_dirac_term(io, row, col, ent, ldims, rdims, isfirstterm)
            if isfirstterm
                isfirstterm = false
            end

            if !_displayall && num_term >= _numhead
                exitloop = true
                break
            end
        end
        exitloop && break
        _newline && print(io, "\n", repeat(" ", length(statename * " = ")-1))
    end

    num_term < length(state) && return println(io, " +...")
    !_newline && println(io)
    return nothing
end

function IO_braket(io::IO, state)
    if !haskey(io, :braket)
        braket = braket_str(state)
        io = IOContext(io, :braket => braket)
    end
    if !haskey(io, :compact)
        io = IOContext(io, :compact => true)
    end
    return io, braket
end

function braket_str(state::PureState)
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited
        braket = ifelse(state isa Vector, ("|", "\\rangle"), ("\\langle", "|"))
    else
        braket = ifelse(state isa Vector, ("|", "⟩"), ("⟨", "|"))
    end
    return braket
end
function braket_str(state::MixedState)
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited
        braket = (("|", "\\rangle"), ("\\langle", "|"))
    else
        braket = (("|", "⟩"), ("⟨", "|"))
    end
    return braket
end


"""
    print_dirac_term(io::IO, idx::Int, value::T, dims::Vector{Int}, isfirstterm=false) where T
    print_dirac_term(io::IO, row::Int, col::Int,
                             value::T, ldims::Vector{Int}, rdims::Vector{Int}, isfirstterm=false) where T
"""
function print_dirac_term(io::IO, idx::Int, value::T, dims::Vector{Int}, isfirstterm=false) where T <: Number
    s = ""
    s *= sprint(x -> print_precision_value(io, value, isfirstterm)) # `x` makes no sense.

    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited
        braket = get(io, :braket, ("|", "\\rangle"))
    else
        braket = get(io, :braket, ("|", "⟩"))
    end
    print(io, s, braket[1], ind2Nary(idx, dims), braket[2])
end
function print_dirac_term(io::IO, row::Int, col::Int,
                          value::T, ldims::Vector{Int}, rdims::Vector{Int}, isfirstterm=false) where T <: Number
    s = ""
    s *= sprint(x -> print_precision_value(io, value, isfirstterm)) # `x` makes no sense.

    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited
        braket = get(io, :braket, (("|", "\\rangle"), ("\\langle", "|")) )
    else
        braket = get(io, :braket, (("|", "⟩"), ("⟨", "|")))
    end
    print(io, s, braket[1][1], ind2Nary(row, ldims), braket[1][2], braket[2][1], ind2Nary(col, rdims), braket[2][2])
end


function print_precision_value(io::IO, z::Complex, isfirstterm::Bool) # https://github.com/JuliaLang/julia/blob/02aa9bbc258a380b5c9fbe2f2d3276a90a72abca/base/complex.jl#L182-L197
    r, i = reim(z)
    istwoterms = !iszero(r) && !iszero(i)
    istwoterms && !isfirstterm && print(io, "+") # both real and imaginary part are nonzero and not first term
    istwoterms && print(io, "(")
    compact = get(io, :compact, false)
    # !isfirstterm && r > 0 && print(io, "+")
    !iszero(r) && print_precision_value(io, r, isfirstterm, istwoterms, true)

    if istwoterms
        if signbit(i) && !isnan(i)
            i = -i
            print(io, compact ? "-" : " - ")
        else
            print(io, compact ? "+" : " + ")
        end
    end

    !iszero(i) && print_precision_value(io, i, isfirstterm, istwoterms, false)
    if !(isa(i,Integer) && !isa(i,Bool) || isa(i,AbstractFloat) && isfinite(i))
        print(io, "*")
    end
    !iszero(i) && print(io, "im")
    !iszero(r) && !iszero(i) && print(io, ")")
    return nothing
end
function print_precision_value(io::IO, val::Union{Float64,Float32}, isfirstterm::Bool, istwoterms::Bool=false, ri::Bool=true)
    iszero(val) && return nothing
    if istwoterms
        if isone(val) || isone(-val)
            return print_one(io, val, ri)
        end
        return print_float(io, val)

    else
        if (isone(val) || isone(-val))
            isfirstterm && return print(io, val > 0 ? "" : "-")
            return print(io, val > 0 ? "+" : "-")
        end
        !isfirstterm && val > 0 && print(io, "+")
        print_float(io, val)
    end
end
function print_precision_value(io::IO, val::Integer, isfirstterm::Bool, istwoterms::Bool=false, ri::Bool=true)
    iszero(val) && return nothing
    if istwoterms
        if isone(val) || isone(-val)
            return print_one(io, val, ri)
        end
        return show(io, val)

    else
        if (isone(val) || isone(-val))
            isfirstterm && return print(io, val > 0 ? "" : "-")
            return print(io, val > 0 ? "+" : "-")
        end
        !isfirstterm && val > 0 && print(io, "+")
        show(io, val)
    end
end
# function print_precision_value(io::IO, val::Integer, isfirstterm::Bool, istwoterms::Bool=false, ri::Bool=true)
#     iszero(val) && return nothing
#     if istwoterms  && (isone(val) || isone(-val))
#         print_one(io, val, ri)
#     else
#         isone(-val) && return print(io, "-")
#         isone(val) && isfirstterm && return print(io, "")
#         isone(val) && !isfirstterm && return print(io, "+")
#         val > 0 && isfirstterm && return print(io, val)
#         val > 0 && return print(io, "+", val)
#         show(io, val)
#     end
# end
function print_float(io::IO, val::Union{Float64,Float32})
    if !iszero(_precision)
        _show(io, val, PRECISION, _precision, val isa Float64, true)
    elseif get(io, :compact, false)
        _show(io, val, PRECISION, 6, val isa Float64, true)
    else
        _show(io, val, SHORTEST, 0, get(io, :typeinfo, Any) !== typeof(val), false)
    end
end
function print_one(io::IO, val::Number, ri::Bool)
    if ri # real part
        isone(val) && return print(io, val)
        isone(-val) && return print(io, val)
    end
end

"""
    ind2Nary(n::Int, dims::Vector{Int})

# Arguments
- `n::Int`: n th row(column) of qudit/operator array.
- `dims::Vector{Int}`: N-ary array
"""
function ind2Nary(m::Int, dims::Vector{Int})
    m = m - 1
    str = ""
    nq = length(dims)
    product = prod(dims[2:end])
    for ith in 1:nq-1
        d = div(m, product)
        m = m - d * product
        product = div(product, dims[ith+1])
        str *= string(d)
    end
    str *= string(m)
    return str
end
