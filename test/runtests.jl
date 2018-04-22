using DiracNotation, QuantumOptics
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

psi1 = basisstate(NLevelBasis(3), 2)
psi2 = basisstate(NLevelBasis(5), 3)

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
@test stdout2str_dirac(psi1) == "Ket(dim=3)\n  basis: NLevel(N=3)\n|ψ⟩ = |1⟩\n"
@test stdout2str_dirac(dagger(psi1)) == "Bra(dim=3)\n  basis: NLevel(N=3)\n⟨ψ| = ⟨1|\n"
@test stdout2str_dirac( (psi1 ⊗ psi1)⊗ dagger(basisstate(NLevelBasis(10), 3)) ) == "DenseOperator(dim=9x10)\n  basis left:  [NLevel(N=3) ⊗ NLevel(N=3)]\n  basis right: NLevel(N=10)\nψ = |11⟩⟨2|\n"
@test stdout2str_dirac( sparse((psi1 ⊗ psi1)⊗ dagger(basisstate(NLevelBasis(10), 3))) ) == "SparseOperator(dim=9x10)\n  basis left:  [NLevel(N=3) ⊗ NLevel(N=3)]\n  basis right: NLevel(N=10)\nψ = |11⟩⟨2|\n"
