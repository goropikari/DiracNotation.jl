using QuantumOptics

function dirac(io::IO, state::Union{Ket, Bra}, statename="ψ")
    summary(io, state)
    data = state.data
    shape = state.basis.shape
    reverse!(shape)
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited # for IJulia rendering
        if statename == "ψ"
            statename = "\\psi"
        end
        if state isa Ket
            str = "\$" * sprint(io -> print_dirac(io, data, shape, statename)) * "\$"
        else
            str = "\$" * sprint(io -> print_dirac(io, transpose(data), shape, statename)) * "\$"
        end
        display("text/markdown", str)
    else
        if state isa Ket
            print_dirac(io, data, shape, statename)
        else
            print_dirac(io, transpose(data), shape, statename)
        end
    end
end
dirac(state::Union{Ket, Bra}, statename="ψ") = dirac(stdout, state, statename)


function dirac(io::IO, state::Union{DenseOperator, SparseOperator}, statename="ρ")
    summary(io, state)
    println(io)
    data = state.data
    lshape = state.basis_l.shape
    rshape = state.basis_r.shape
    # print_dirac(io, data, lshape, rshape, statename)
    reverse!(lshape)
    reverse!(rshape)
    if _islatex && isdefined(Main, :IJulia) && Main.IJulia.inited # for IJulia rendering
        if statename == "ρ"
            statename = "\\rho"
        end
        str = "\$" * sprint(io -> print_dirac(io, data, lshape, rshape, statename)) * "\$"

        display("text/markdown", str)
    else
        print_dirac(io, data, lshape, rshape, statename)
    end
end
dirac(state::Union{DenseOperator, SparseOperator}, statename="ρ") = dirac(stdout, state, statename)
