# DiracNotation

[![Build Status](https://travis-ci.org/goropikari/DiracNotation.jl.svg?branch=master)](https://travis-ci.org/goropikari/DiracNotation.jl)
[![Coverage Status](https://coveralls.io/repos/goropikari/DiracNotation.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/goropikari/DiracNotation.jl?branch=master)
[![codecov.io](http://codecov.io/github/goropikari/DiracNotation.jl/coverage.svg?branch=master)](http://codecov.io/github/goropikari/DiracNotation.jl?branch=master)

[DiracNotation.jl](https://github.com/goropikari/DiracNotation.jl) is a package to print Dirac notation rendering for Bra, Ket, and Operator in [QuantumOptics.jl](https://github.com/qojulia/QuantumOptics.jl).  
By using this package, matrix representation is changed into Dirac notation.

## Installation
```julia
Pkg.clone("https://github.com/goropikari/DiracNotation.jl")
```

## Usage
This package is used with [QuantumOptics.jl](https://github.com/qojulia/QuantumOptics.jl).
```julia
julia> using QuantumOptics, DiracNotation

julia> basis = SpinBasis(1//2)
Spin(1/2)

julia> psi1 = basisstate(basis, 1)
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = |0⟩

julia> println(psi1) # QuantumOptics.jl style
Ket(dim=2)
  basis: Spin(1/2)
 1.0+0.0im
 0.0+0.0im

julia> psi2 = basisstate(basis, 2)
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = |1⟩

julia> psi3 = basisstate(NLevelBasis(4), 3)
Ket(dim=4)
  basis: NLevel(N=4)
|State⟩ = |2⟩

julia> dm(psi1)
DenseOperator(dim=2x2)
  basis: Spin(1/2)
State = |0⟩⟨0|

julia> (psi1 ⊗ psi2) ⊗ dagger(psi3)
DenseOperator(dim=4x4)
  basis left:  [Spin(1/2) ⊗ Spin(1/2)]
  basis right: NLevel(N=4)
State = |01⟩⟨2|

julia> set_statename("ψ") # change the name of LHS

julia> psi1
Ket(dim=2)
  basis: Spin(1/2)
|ψ⟩ = |0⟩

julia> dirac(psi1, "ϕ")
Ket(dim=2)
  basis: Spin(1/2)
|ϕ⟩ = |0⟩
```


On IJulia, Dirac notation is rendered by MathJax.  
**Example**
- [QuantumOptics version](https://nbviewer.jupyter.org/github/goropikari/DiracNotation.jl/blob/master/examples/QuantumOptics.ipynb)
- [DiracNotation version](https://nbviewer.jupyter.org/github/goropikari/DiracNotation.jl/blob/master/examples/braket.ipynb)
