import LinearAlgebra: Adjoint, Transpose
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
const MixedState =  Union{Matrix, Adjoint{T,Matrix{T}}, Transpose{T,Matrix{T}}} where T

function reset_properties()
    set_properties(precision=0, islatex=true, displayall=true, numhead=5, newline=false)
end
reset_properties()

"""
    dirac
"""
function dirac(io::IO, state::PureState, shape::Vector{Int}, statename::String="ψ")
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited # for IJulia rendering
        if statename == "ψ"
            statename = "\\psi"
        end
        str = "\$" * sprint(io -> print_dirac(io, state, shape, statename)) * "\$"
        display("text/markdown", str)
    else
        print_dirac(io, state, shape, statename)
    end
end
dirac(state::PureState, shape::Vector{Int}, statename::String="ψ") = dirac(stdout, state, shape, statename)
function dirac(io::IO, state::PureState, statename::String="ψ")
    n = log2(length(state))
    @assert isinteger(n)
    shape = fill(2, (Int(n), ))
    dirac(io, state, shape, statename)
end
dirac(state::PureState, statename::String="ψ") = dirac(stdout, state, statename)

function dirac(io::IO, state::MixedState, lshape::Vector{Int}, rshape::Vector{Int}, statename::String="ρ")
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited # for IJulia rendering
        if statename == "ρ"
            statename = "\\hat{\\rho}"
        end
        str = "\$" * sprint(io -> print_dirac(io, state, lshape, rshape, statename)) * "\$"
        display("text/markdown", str)
    else
        print_dirac(io, state, lshape, rshape, statename)
    end
end
dirac(state::MixedState, lshape::Vector{Int}, rshape::Vector{Int}, statename::String="ρ") = dirac(stdout, state, lshape, rshape, statename)
function dirac(io::IO, state::MixedState, statename::String="ρ")
    row, col = size(state)
    n, m = log2(row), log2(col)
    @assert isinteger(n) || isinteger(m)
    lshape, rshape = fill(2, (Int(n), )), fill(2, (Int(m), ))
    dirac(io, state, lshape, rshape, statename)
end
dirac(state::MixedState, statename::String="ρ") = dirac(stdout, state, statename)

"""
    print_dirac(io::IO, state::PureState, shape::Vector{Int}, statename::String="ψ")
    print_dirac(io::IO, state::MixedState,
                        lshape::Vector{Int},
                        rshape::Vector{Int},
                        statename::String="ρ") where T <: Number
"""
function print_dirac(io::IO, state::PureState, shape::Vector{Int}, statename::String="ψ")
    io, braket = IO_braket(io, state)

    isfirstterm = true
    s = "$(braket[1])$(statename)$(braket[2]) = "
    print(io, s)

    numnz = count(!iszero, state)
    num_term = 0
    for (idx, ent) in enumerate(state)
        num_term += 1
        iszero(ent) && continue
        if ent ≈ one(ent)
            ent = one(ent)
        end
        print_dirac_term(io, idx, ent, shape, isfirstterm)
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
                             lshape::Vector{Int},
                             rshape::Vector{Int},
                             statename::String="ρ") where T <: Number
    nrow, ncol = size(state)
    @assert nrow == prod(lshape) && ncol == prod(rshape)
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

            print_dirac_term(io, row, col, ent, lshape, rshape, isfirstterm)
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
    print_dirac_term(io::IO, idx::Int, value::T, shape::Vector{Int}, isfirstterm=false) where T
    print_dirac_term(io::IO, row::Int, col::Int,
                             value::T, lshape::Vector{Int}, rshape::Vector{Int}, isfirstterm=false) where T
"""
function print_dirac_term(io::IO, idx::Int, value::T, shape::Vector{Int}, isfirstterm=false) where T
    s = ""
    s *= first_term_val(value, isfirstterm)
    absval = abs(value)
    if !isone(absval)
        s *= sprint(print_precision_value, absval, context=io) # 桁数とかはここで決まる
    end
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited
        braket = get(io, :braket, ("|", "\\rangle"))
    else
        braket = get(io, :braket, ("|", "⟩"))
    end
    print(io, s, braket[1], ind2Nary(idx, shape), braket[2])
end
function print_dirac_term(io::IO, row::Int, col::Int,
                          value::T, lshape::Vector{Int}, rshape::Vector{Int}, isfirstterm=false) where T
    s = ""
    s *= first_term_val(value, isfirstterm)
    absval = abs(value)
    if !isone(absval)
        s *= sprint(print_precision_value, absval, context=io)
    end
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited
        braket = get(io, :braket, (("|", "\\rangle"), ("\\langle", "|")) )
    else
        braket = get(io, :braket, (("|", "⟩"), ("⟨", "|")))
    end
    print(io, s, braket[1][1], ind2Nary(row, lshape), braket[1][2], braket[2][1], ind2Nary(col, rshape), braket[2][2])
end

function first_term_val(value, isfirstterm::Bool)
    if value > zero(value)
        !isfirstterm && return '+' # remove '+' sign if the term is first,
    else
        return '-'
    end
    return ""
end

function print_precision_value(io::IO, val::Union{Float64,Float32})
    if !iszero(_precision)
        _show(io, val, PRECISION, _precision, val isa Float64, true)
    elseif get(io, :compact, false)
        _show(io, val, PRECISION, 6, val isa Float64, true)
    else
        _show(io, val, SHORTEST, 0, get(io, :typeinfo, Any) !== typeof(val), false)
    end
end
print_precision_value(io::IO, val) = show(io, val)


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
