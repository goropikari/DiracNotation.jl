using DiracNotation, QuantumOptics
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

psi1 = basisstate(NLevelBasis(3), 2)
psi2 = basisstate(NLevelBasis(5), 3)
spin1 = basisstate(SpinBasis(1//2), 1)
spin2 = basisstate(SpinBasis(3//2), 4)

# Fock
N = 10
b = FockBasis(N)
alpha = 0.4

# ref.
# Capture the output of Julia's console: Michael Hatherly's code and Steven G. Johnson's code
# https://groups.google.com/forum/#!topic/julia-users/3wGChHHYoxo
function stdout2str(x)
    buf = IOBuffer();
    td = TextDisplay(buf);
    display(td, x);
    str = String(take!(buf))
end
function stdout2str_dirac(x::Union{Ket,Bra,Operator}, statename::String="ψ")
    rdstdout, wrstdout = redirect_stdout()
    dirac(x, statename)
    s = convert(String, readavailable(rdstdout))
end
@test stdout2str(psi1) == "Ket(dim=3)\n  basis: NLevel(N=3)\n|State⟩ = |1⟩"
@test stdout2str(dagger(psi1)) == "Bra(dim=3)\n  basis: NLevel(N=3)\n⟨State| = ⟨1|"
@test stdout2str(psi1 ⊗ psi1) == "Ket(dim=9)\n  basis: [NLevel(N=3) ⊗ NLevel(N=3)]\n|State⟩ = |11⟩"
@test stdout2str(dagger(psi1 ⊗ psi1)) == "Bra(dim=9)\n  basis: [NLevel(N=3) ⊗ NLevel(N=3)]\n⟨State| = ⟨11|"
@test stdout2str(dagger(psi1 ⊗ psi2)) == "Bra(dim=15)\n  basis: [NLevel(N=3) ⊗ NLevel(N=5)]\n⟨State| = ⟨12|"
@test stdout2str(dm(psi1)) == "DenseOperator(dim=3x3)\n  basis: NLevel(N=3)State = |1⟩⟨1|"
@test stdout2str(sparse(dm(psi1))) == "SparseOperator(dim=3x3)\n  basis: NLevel(N=3)State = |1⟩⟨1|"
@test stdout2str(psi1 ⊗ dagger(psi2)) == "DenseOperator(dim=3x5)\n  basis left:  NLevel(N=3)\n  basis right: NLevel(N=5)State = |1⟩⟨2|"
@test stdout2str(sparse(psi1 ⊗ dagger(psi2))) == "SparseOperator(dim=3x5)\n  basis left:  NLevel(N=3)\n  basis right: NLevel(N=5)State = |1⟩⟨2|"
@test stdout2str((psi1 ⊗ psi1)⊗ dagger(basisstate(NLevelBasis(10), 3))) == "DenseOperator(dim=9x10)\n  basis left:  [NLevel(N=3) ⊗ NLevel(N=3)]\n  basis right: NLevel(N=10)State = |11⟩⟨2|"
@test stdout2str(sigmay(SpinBasis(1//2)) * spin1) == "Ket(dim=2)\n  basis: Spin(1/2)\n|State⟩ = i|1⟩"
@test stdout2str( dagger(sigmay(SpinBasis(1//2)) * spin1) ) == "Bra(dim=2)\n  basis: Spin(1/2)\n⟨State| = -i⟨1|"
@test stdout2str( spin1 + sigmax(SpinBasis(1//2)) * spin1 ) == "Ket(dim=2)\n  basis: Spin(1/2)\n|State⟩ = |0⟩ + 1.0|1⟩"
@test stdout2str( spin1 + sigmaz(SpinBasis(1//2)) * sigmax(SpinBasis(1//2)) * spin1 ) == "Ket(dim=2)\n  basis: Spin(1/2)\n|State⟩ = |0⟩ -1.0|1⟩"
@test stdout2str( coherentstate(b, alpha) ) == "Ket(dim=11)\n  basis: Fock(cutoff=10)\n|State⟩ = 0.923|0⟩ + 0.369|1⟩ + 0.104|2⟩ + 0.024|3⟩ + 0.005|4⟩ + 0.001|5⟩ + 0.0|6⟩ + 0.0|7⟩ + 0.0|8⟩ + 0.0|9⟩ + 0.0|10⟩"
@test stdout2str( destroy(b) ) == "SparseOperator(dim=11x11)\n  basis: Fock(cutoff=10)State = |0⟩⟨1|+1.414 |1⟩⟨2|+1.732 |2⟩⟨3|+2.0 |3⟩⟨4|+2.236 |4⟩⟨5|+2.449 |5⟩⟨6|+2.646 |6⟩⟨7|+2.828 |7⟩⟨8|+3.0 |8⟩⟨9|+3.162 |9⟩⟨10|"

@test stdout2str_dirac(psi1) == "Ket(dim=3)\n  basis: NLevel(N=3)\n|ψ⟩ = |1⟩\n"
@test stdout2str_dirac(dagger(psi1)) == "Bra(dim=3)\n  basis: NLevel(N=3)\n⟨ψ| = ⟨1|\n"
@test stdout2str_dirac( (psi1 ⊗ psi1)⊗ dagger(basisstate(NLevelBasis(10), 3)) ) == "DenseOperator(dim=9x10)\n  basis left:  [NLevel(N=3) ⊗ NLevel(N=3)]\n  basis right: NLevel(N=10)\nψ = |11⟩⟨2|\n"
@test stdout2str_dirac( sparse((psi1 ⊗ psi1)⊗ dagger(basisstate(NLevelBasis(10), 3))) ) == "SparseOperator(dim=9x10)\n  basis left:  [NLevel(N=3) ⊗ NLevel(N=3)]\n  basis right: NLevel(N=10)\nψ = |11⟩⟨2|\n"
