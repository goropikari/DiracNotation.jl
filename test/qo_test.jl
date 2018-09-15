using QuantumOptics

@testset "QuantumOptics" begin

    Random.seed!(0)
    b = SpinBasis(1//2)
    psi0 = spinup(b)
    psi1 = spindown(b)

    @test sprint(dirac, psi0) == "Ket(dim=2)\n  basis: Spin(1/2)\n|ψ⟩ = |0⟩\n"
    @test sprint(dirac, psi1) == "Ket(dim=2)\n  basis: Spin(1/2)\n|ψ⟩ = |1⟩\n"
    # sprint(dirac, psi0)
    # sprint(dirac, psi1)
    @test sprint(dirac, psi0 ⊗ psi1) == "Ket(dim=4)\n  basis: [Spin(1/2) ⊗ Spin(1/2)]\n|ψ⟩ = |10⟩\n"
    @test sprint(dirac, psi1 ⊗ psi0) == "Ket(dim=4)\n  basis: [Spin(1/2) ⊗ Spin(1/2)]\n|ψ⟩ = |01⟩\n"
    @show psi = randstate(b)
    @show psi ⊗ dagger(psi)
    @test sprint(dirac, psi) == "Ket(dim=2)\n  basis: Spin(1/2)\n|ψ⟩ = (0.65825+0.727547im)|0⟩+(0.131519+0.141719im)|1⟩\n"
    @test sprint(dirac, psi ⊗ dagger(psi)) == "DenseOperator(dim=2x2)\n  basis: Spin(1/2)\nρ = 0.962618|0⟩⟨0|+(0.18968+0.00239967im)|0⟩⟨1|+(0.18968-0.00239967im)|1⟩⟨0|+0.0373817|1⟩⟨1|\n"
    @test sprint(dirac, sparse( psi ⊗ dagger(psi)) ) == "SparseOperator(dim=2x2)\n  basis: Spin(1/2)\nρ = 0.962618|0⟩⟨0|+(0.18968+0.00239967im)|0⟩⟨1|+(0.18968-0.00239967im)|1⟩⟨0|+0.0373817|1⟩⟨1|\n"

end # "QuantumOptics"
