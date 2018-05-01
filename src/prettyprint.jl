using QuantumOptics
import QuantumOptics.printing: showoperatorheader, permuted_sparsedata, permuted_densedata, _std_order
import Base.show
export dirac

print_with_color(:cyan,
                """
                    DiracNotation.jl: By default, states are printed in standard order.
                """)

"""
    set_properties(; statename = "State",
                      round_digit = 3,
                      number_term = 8,
                      isallterms = false,
                      isdirac = true,
                      standard_order = true)

Set default properties.

# Arguments
- `statename::String`: Default state name.
- `round_digit::Int`: Rounds number for display.
- `number_term::Int`: The number of displayed terms.
- `isallterms::Bool`: If this is `true`, show all terms.
- `isdirac::Bool`: `true` -> Dirac notation. `false` -> matrix style
- `standard_order`: In detail, please read [QuantumOptics.jl Official documentation](https://qojulia.org/documentation/quantumobjects/operators.html#tensor_order-1).
                    If `isdirac` is `true` and `standard_order` is `false`, the most right hand side
                    is the first state, i.e., `spinup(SpisBasis(1//2)) ⊗ spindown(SpinBasis(1//2))` (``|01⟩`` in standard order)
                    is displayed as ``|10⟩``.
"""
function set_properties(; statename::String=_state_name,
                          round_digit::Int=_digit,
                          number_term::Int=_num_term,
                          isallterms::Bool=_display_all_term,
                          isdirac::Bool=_diracstyle,
                          standard_order::Bool=_std_order)
    global _state_name = statename
    global _digit = round_digit
    global _num_term = number_term
    global _display_all_term = isallterms
    global _diracstyle = isdirac
    QuantumOptics.set_printing(standard_order=standard_order)
    nothing
end
if isdefined(Main, :IJulia) && Main.IJulia.inited
    set_properties(statename="\\mathrm{State}", round_digit=3, number_term=8, isallterms=false, isdirac=true, standard_order=true)
else
    set_properties(statename="State", round_digit=3, number_term=8, isallterms=false, isdirac=true, standard_order=true)
end

"""
    print_plain_in_md(io::IO, x::AbstractArray)

Replace `\n` and ` ` (empty space) with `<br>` and `&nbsp;`, respectively.
"""
function print_plain_in_md(io::IO, x::AbstractArray)
    if isdefined(Main, :IJulia) && Main.IJulia.inited
        str = Main.IJulia.limitstringmime(MIME("text/plain"), x)
        n = search(str, '\n')
        str = str[n+1:end]
    else
        str = sprint((u, v) -> Base.print_matrix(IOContext(u, :limit => true, :compact => true), v, " ", "  ", "", "  \u2026  ", "\u22ee", "  \u22f1  "), x)
    end

    str = replace(str, "\n", "<br>")
    str = replace(str, "  \u2026  ", "  \u2026 ")
    str = replace(str, "  \u22f1  ", "\u22f1")
    str = replace(str, " ", "&nbsp;&nbsp;")
    print(io, str)
end

"""
    showoperatorheader_md(io::IO, x::Union{DenseOperator,SparseOperator})

Show `Operator` header by markdown.
"""
function showoperatorheader_md(io::IO, x::Union{DenseOperator,SparseOperator})
    print(io, "$(typeof(x).name.name)(dim=$(length(x.basis_l))x$(length(x.basis_r)))<br>")
    if bases.samebases(x)
        print(io, "&nbsp;&nbsp;&nbsp;&nbsp;  basis: ")
        print(io, basis(x), "<br>")
    else
        print(io, "&nbsp;&nbsp;&nbsp;&nbsp;  basis left:  &nbsp;&nbsp;")
        print(io, x.basis_l)
        print(io, "<br>&nbsp;&nbsp;&nbsp;&nbsp;  basis right: ")
        print(io, x.basis_r)
        print(io, "<br>")
    end
end

"""
    permuted_braketdata(x::Union{Ket,Bra})

Permute data in reverse order.
"""
function permuted_braketdata(x::Union{Ket,Bra})
    perm = collect(length(basis(x).shape):-1:1)
    return permutesystems(x, perm).data
end

function show(io::IO, ::MIME"text/markdown", x::Ket)
    if _diracstyle
        print(io, "Ket(dim=$(length(x.basis)))<br> &nbsp;&nbsp;&nbsp;&nbsp; basis: $(x.basis)<br>")
        str = md(x, _state_name)
        print(io, "\$" * str * "\$")
    else
        print(io, "Ket(dim=$(length(x.basis)))<br> &nbsp;&nbsp;&nbsp;&nbsp; basis: $(x.basis)<br>")
        if _std_order
            print_plain_in_md(io, permuted_braketdata(x) )
        else
            print_plain_in_md(io, x.data)
        end
    end
end
function show(io::IO, ::MIME"text/plain", x::Ket)
    if _diracstyle
        print(io, "Ket(dim=$(length(x.basis)))\n  basis: $(x.basis)\n")
        str = aa(x, _state_name)
        print(io, str)
    else
        show(io, x) # call the method in QuantumOptics.jl
    end
end
function show(io::IO, ::MIME"text/markdown", x::Bra)
    if _diracstyle
        print(io, "Bra(dim=$(length(x.basis)))<br> &nbsp;&nbsp;&nbsp;&nbsp; basis: $(x.basis)<br>")
        str = md(x, _state_name)
        print(io, "\$" * str * "\$")
    else
        print(io, "Bra(dim=$(length(x.basis)))<br> &nbsp;&nbsp;&nbsp;&nbsp; basis: $(x.basis)<br>")
        if _std_order
            print_plain_in_md(io, permuted_braketdata(x) )
        else
            print_plain_in_md(io, x.data)
        end
    end
end
function show(io::IO, ::MIME"text/plain", x::Bra)
    if _diracstyle
        print(io, "Bra(dim=$(length(x.basis)))\n  basis: $(x.basis)\n")
        str = aa(x, _state_name)
        print(io, str)
    else
        show(io, x) # call the method in QuantumOptics.jl
    end
end
function show(io::IO, ::MIME"text/markdown", x::DenseOperator)
    if _diracstyle
        showoperatorheader_md(io, x)
        str = md(x, _state_name)
        print(io, "\$" * str * "\$")
    else
        showoperatorheader_md(io, x)
        if _std_order
            print_plain_in_md(io, permuted_densedata(x) )
        else
            print_plain_in_md(io, x.data)
        end
    end
end
function show(io::IO, ::MIME"text/markdown", x::SparseOperator)
    if _diracstyle
        showoperatorheader_md(io, x)
        str = md(x, _state_name)
        print(io, "\$" * str * "\$")
    else
        showoperatorheader_md(io, x)
        if _std_order
            print_plain_in_md(io, permuted_sparsedata(x) )
        else
            print_plain_in_md(io, x.data)
        end
    end
end
function show(io::IO, ::MIME"text/plain", x::Union{DenseOperator,SparseOperator})
    if _diracstyle
        showoperatorheader(io, x)
        println()
        str = aa(x, _state_name)
        print(io, str)
    else
        show(io, x) # call the method in QuantumOptics.jl
    end
end

"""
    md(x::Union{Ket,Bra}, statename::String)
    md(x::Union{DenseOperator,SparseOperator}, statename::String)

Generate markdown for Dirac notation
"""
function md(x::Union{Ket,Bra}, statename::String)
    nq = length(x.basis.shape)

    if _std_order
        shape = x.basis.shape
        perm = collect(reverse(1:nq))
        if nq != 1
            x = permutesystems(x, perm)
        end
    else
        shape = reverse(x.basis.shape)
    end
    data = x.data

    braket = ifelse(typeof(x) == Ket, ["|", "\\rangle"], ["\\langle", "|"])
    isfirstterm = true
    numnz = countnz(data)
    numprint = 0

    str = "$(braket[1]) $(statename) $(braket[2]) = "
    for (idx, ent) in enumerate(data)
        if !(_display_all_term) && (numnz > _num_term) && ( div(_num_term, 2) <= numprint < numnz - div(_num_term, 2) - isodd(_num_term)) && !(ent≈0)
            if numprint == div(_num_term, 2)
                str *= " + \\cdots "
            end
            numprint += 1
            continue
        end

        if ent ≈ 1
            value = 1.0
        else
            value = ent
        end
        if !(ent ≈ 0)
            numprint += 1
            if isfirstterm
                isfirstterm = false
                if value == 1.
                    str *= "$(braket[1]) $(ind2Nary(idx, shape)) $(braket[2])"
                else
                    str *= "$(n2s(ent)) $(braket[1]) $(ind2Nary(idx, shape)) $(braket[2])"
                end
            else
                if n2s(ent)[1] == '-'
                    str *= "$(n2s(ent)) $(braket[1]) $(ind2Nary(idx, shape)) $(braket[2])"
                else
                    str *= "+$(n2s(ent)) $(braket[1]) $(ind2Nary(idx, shape)) $(braket[2])"
                end
            end
        end
    end

    return str
end
function md(x::Union{DenseOperator,SparseOperator}, statename::String)
    ncol = prod(x.basis_r.shape)
    nrow = prod(x.basis_l.shape)

    if _std_order
        rshape = x.basis_r.shape
        lshape = x.basis_l.shape
        if typeof(x) == DenseOperator
            data = permuted_densedata(x)
        elseif typeof(x) == SparseOperator
            data = permuted_sparsedata(x)
        end
    else
        rshape = reverse(x.basis_r.shape)
        lshape = reverse(x.basis_l.shape)
        data = x.data
    end

    isfirstterm = true
    numnz = countnz(data)
    numprint = 0

    str = "$(statename) = "
    for i in 1:nrow
        for j in 1:ncol
            ent = data[i,j]

            if !(_display_all_term) && (numnz > _num_term) && ( div(_num_term, 2) <= numprint < numnz - div(_num_term, 2) - isodd(_num_term) ) && !(ent≈0)
                if numprint == div(_num_term, 2)
                    str *= " + ⋯ "
                end
                numprint += 1
                continue
            end

            if ent ≈ 1
                value = 1.0
            else
                value = ent
            end
            if !(ent ≈ 0)
                numprint += 1
                if isfirstterm
                    isfirstterm = false
                    if value == 1.
                        str *= "| $(ind2Nary(i, lshape)) \\rangle \\langle $(ind2Nary(j, rshape)) |"
                    else
                        str *= "$(n2s(ent)) | $(ind2Nary(i, lshape)) \\rangle \\langle $(ind2Nary(j, rshape)) |"
                    end
                else
                    if value == 1.0
                        str *= "+ | $(ind2Nary(i, lshape)) \\rangle \\langle $(ind2Nary(j, rshape)) |"
                    elseif n2s(ent)[1] == '-'
                        str *= "$(n2s(ent)) | $(ind2Nary(i, lshape)) \\rangle \\langle $(ind2Nary(j, rshape)) |"
                    else
                        str *= "+$(n2s(ent)) | $(ind2Nary(i, lshape)) \\rangle \\langle $(ind2Nary(j, rshape)) |"
                    end
                end
            end

        end
    end

    return str
end

"""
    aa(x::Union{Ket,Bra}, statename::String="")
    aa(x::Union{DenseOperator,SparseOperator}, statename::String="")

Generate ASCIIart for Dirac notation.
"""
function aa(x::Union{Ket,Bra}, statename::String="")
    nq = length(x.basis.shape)
    if _std_order
        shape = x.basis.shape
        perm = collect(reverse(1:nq))
        if nq != 1
            x = permutesystems(x, perm)
        end
    else
        shape = reverse(x.basis.shape)
    end
    data = x.data

    braket = ifelse(typeof(x) == Ket, ["|", "⟩"], ["⟨", "|"])
    isfirstterm = true
    numnz = countnz(data)
    numprint = 0

    str = "$(braket[1])$(statename)$(braket[2]) = "
    for (idx, ent) in enumerate(data)
        if !(_display_all_term) && (numnz > _num_term) && ( div(_num_term, 2) <= numprint < numnz - div(_num_term, 2) - isodd(_num_term)) && !(ent≈0)
            if numprint == div(_num_term, 2)
                str *= " + ⋯ "
            end
            numprint += 1
            continue
        end

        if ent ≈ 1
            value = 1.0
        else
            value = ent
        end
        if !(ent ≈ 0)
            numprint += 1
            if isfirstterm
                isfirstterm = false
                if value == 1.
                    str *= "$(braket[1])$(ind2Nary(idx, shape))$(braket[2])"
                else
                    str *= "$(n2s(ent))$(braket[1])$(ind2Nary(idx, shape))$(braket[2])"
                end
            else
                if n2s(ent)[1] == '-'
                    str *= " $(n2s(ent))$(braket[1])$(ind2Nary(idx, shape))$(braket[2])"
                else
                    str *= " + $(n2s(ent))$(braket[1])$(ind2Nary(idx, shape))$(braket[2])"
                end
            end
        end
    end

    return str
end
function aa(x::Union{DenseOperator,SparseOperator}, statename::String="")
    ncol = prod(x.basis_r.shape)
    nrow = prod(x.basis_l.shape)

    if _std_order
        rshape = x.basis_r.shape
        lshape = x.basis_l.shape
        if typeof(x) == DenseOperator
            data = permuted_densedata(x)
        elseif typeof(x) == SparseOperator
            data = permuted_sparsedata(x)
        end
    else
        rshape = reverse(x.basis_r.shape)
        lshape = reverse(x.basis_l.shape)
        data = x.data
    end

    isfirstterm = true
    numnz = countnz(data)
    numprint = 0

    str = "$(statename) = "
    for i in 1:nrow
        for j in 1:ncol
            ent = data[i,j]

            if !(_display_all_term) && (numnz > _num_term) && ( div(_num_term, 2) <= numprint < numnz - div(_num_term, 2) - isodd(_num_term) ) && !(ent≈0)
                if numprint == div(_num_term, 2)
                    str *= " + ⋯ "
                end
                numprint += 1
                continue
            end


            if ent ≈ 1
                value = 1.0
            else
                value = ent
            end
            if !(ent ≈ 0)
                numprint += 1
                if isfirstterm
                    isfirstterm = false
                    if value == 1.
                        str *= "|$(ind2Nary(i, lshape))⟩⟨$(ind2Nary(j, rshape))|"
                    else
                        str *= "$(n2s(ent)) |$(ind2Nary(i, lshape))⟩⟨$(ind2Nary(j, rshape))|"
                    end
                else
                    if value == 1.0
                        str *= " + |$(ind2Nary(i, lshape))⟩⟨$(ind2Nary(j, rshape))|"
                    elseif n2s(ent)[1] == '-'
                        str *= " $(n2s(ent)) |$(ind2Nary(i, lshape))⟩⟨$(ind2Nary(j, rshape))|"
                    else
                        str *= " +$(n2s(ent)) |$(ind2Nary(i, lshape))⟩⟨$(ind2Nary(j, rshape))|"
                    end
                end
            end

        end
    end
    return str
end

"""
    n2s(x)

number to string for pretty print.
"""
function n2s(x::T) where T <: Complex
    str = ""
    str1, str2 = "", ""
    if !(x.re ≈ 0)
        str1 *= "$(round(x.re, _digit))"
    end
    if !(x.im ≈ 0)
        if x.im ≈ one(x.im)
            str2 *= "i"
        elseif -x.im ≈ one(x.im)
            str2 *= "-i"
        else
            str2 *= "$(round(x.im, _digit))i"
        end
    end
    if !isempty(str1) && x.im > zero(x.im)
        str2 = "+" * str2
    end
    str = str1 * str2
    if !isempty(str1) && !isempty(str2)
        str = "(" * str * ")"
    end
    return str
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
function ind2Nary_array(m::Int, dims::Vector{Int})
    m = m - 1
    nq = length(dims)
    ar = zeros(Int, nq)
    product = prod(dims[2:end])
    for ith in 1:nq-1
        d = div(m, product)
        m = m - d * product
        product = div(product, dims[ith+1])
        ar[ith] = d
    end
    ar[end] = m
    return ar
end
"""
    Nary2ind(x, dims) -> index

Return index from n-ary array and dimension list
"""
function Nary2ind(x::Vector{Int}, dims::Vector{Int})
    tmp = 0
    if length(x) != length(dims)
        error()
    end
    nterms = length(x)
    tp = prod(dims[2:end])
    for i in 1:nterms-1
        tmp += x[i] * tp
        tp = div(tp, dims[i+1])
    end
    tmp += x[end] + 1
end

function mirror_world_index(i::Int, dims::Vector{Int})
    return Nary2ind( reverse(ind2Nary_array(i, dims)), reverse(dims)  )
end

"""
    permuted_densedata2(x::DenseOperator)

(Experimental) Maybe this is equivalent to permuted_densedata in QuantumOptics.jl.
But I cannot guarantee.
"""
function permuted_densedata2(x::DenseOperator)
    lshape = x.basis_l.shape
    rshape = x.basis_r.shape
    lbn = length(lshape)
    rbn = length(rshape)

    perm = Int[collect(lbn:-1:1); collect(lbn+rbn:-1:lbn+1)]
    data = reshape(x.data,  [lshape; rshape]...)
    data = permutedims(data, perm)
    data = reshape(data, size(x.data))

    return round.(data, machineprecorder)
end


"""
    dirac(x, statename="ψ") # for Ket and Bra
    dirac(x, statename="Operator") # for Operator

LaTeX (ASCII art) rendering for composite (SpinBasis and NLevelBasis) system's Ket, Bra, and Operator on IJulia (REPL).
If you use this on IJulia, you can change LHS state name by second argument.

# Example (REPL)
```
julia> b = SpinBasis(1//2)
Spin(1/2)

julia> psi1 = basisstate(b, 1)
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = |0⟩

julia> psi2 = basisstate(b, 2)
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = |1⟩

julia> psi3 = basisstate(SpinBasis(1), 3)
Ket(dim=3)
  basis: Spin(1)
|State⟩ = |2⟩

julia> psi1 ⊗ psi2
Ket(dim=4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
|State⟩ = |01⟩

julia> dirac(psi1 ⊗ psi2, "ψ")
Ket(dim=4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
|ψ⟩ = |01⟩

julia> dm(psi1 ⊗ psi2)
DenseOperator(dim=4x4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
State = |01⟩⟨01|

julia> psi1 ⊗ dagger(psi2 ⊗ psi3)
DenseOperator(dim=2x6)
  basis left:  Spin(1/2)
  basis right: [Spin(1/2) ⊗ Spin(1)]
State = |0⟩⟨12|

julia> dirac(psi1 ⊗ dagger(psi2 ⊗ psi3), "ρ")
DenseOperator(dim=2x6)
  basis left:  Spin(1/2)
  basis right: [Spin(1/2) ⊗ Spin(1)]
ρ = |0⟩⟨12|
```
"""
function dirac(io::IO, x::Union{Ket,Bra}, statename::String="")
    if isempty(statename) && isdefined(Main, :IJulia) && Main.IJulia.inited
        statename = "\\psi"
    elseif isempty(statename)
        statename = "ψ"
    end

    ketbra = ifelse(typeof(x) == Ket, "Ket", "Bra")
    if isdefined(Main, :IJulia) && Main.IJulia.inited
        display("text/markdown", "$(ketbra)(dim=$(length(x.basis)))<br> &nbsp;&nbsp;&nbsp;&nbsp; basis: $(x.basis)<br>")
        str = md(x, statename)
        display("text/latex", "\$" * str * "\$")
    else
        print(io, "$(ketbra)(dim=$(length(x.basis)))\n  basis: $(x.basis)\n")
        str = aa(x, statename)
        println(io, str)
    end
end
dirac(x::Union{Ket,Bra}, statename::String="") = dirac(STDOUT, x, statename)
function dirac(io, x::Union{DenseOperator,SparseOperator}, statename::String="")
    if isempty(statename) && isdefined(Main, :IJulia) && Main.IJulia.inited
        statename = "\\mathrm{Operator}"
    elseif isempty(statename)
        statename = "Operator"
    end

    if isdefined(Main, :IJulia) && Main.IJulia.inited
        header = "$(typeof(x).name.name)(dim=$(length(x.basis_l))x$(length(x.basis_r)))<br>"
        if bases.samebases(x)
            header *= "&nbsp;&nbsp;&nbsp;&nbsp;  basis: " * string(basis(x))
            display("text/markdown", header)
        else
            header *= "&nbsp;&nbsp;&nbsp;&nbsp;  basis left:  " * string(x.basis_l) * "<br>" *
                        "&nbsp;&nbsp;&nbsp;&nbsp;  basis right: " * string(x.basis_r)
            display("text/markdown", header)
        end
        str = md(x, statename)
        display("text/latex", "\$" * str * "\$")
    else
        println(io, "$(typeof(x).name.name)(dim=$(length(x.basis_l))x$(length(x.basis_r)))")
        if bases.samebases(x)
            println(io, "  basis: ", basis(x))
        else
            println(io, "  basis left:  ", x.basis_l)
            println(io, "  basis right: ", x.basis_r)
        end
        str = aa(x, statename)
        println(io, str)
    end
end
dirac(x::Union{DenseOperator,SparseOperator}, statename::String="") = dirac(STDOUT, x, statename)
