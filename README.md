# DiracNotation

[![Build Status](https://travis-ci.org/goropikari/DiracNotation.jl.svg?branch=master)](https://travis-ci.org/goropikari/DiracNotation.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/e1r7f7i05myjnyg0?svg=true)](https://ci.appveyor.com/project/goropikari/quantuminformation-jl)
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
After importing this package, all states are shown by Dirac Notation.

### Simple example
```julia
julia> using QuantumOptics, DiracNotation

julia> basis = SpinBasis(1//2)
Spin(1/2)

julia> srand(2018);

julia> randstate(SpinBasis(1//2) ⊗ SpinBasis(3//2))
Ket(dim=8)
  basis: [Spin(1/2) ⊗ Spin(3/2)]
|State⟩ = (0.263+0.044i)|00⟩ + (0.105+0.274i)|01⟩ + (0.394+0.304i)|02⟩ + (0.39+0.388i)|03⟩ + (0.29+0.289i)|10⟩ + (0.061+0.246i)|11⟩ + (0.143+0.105i)|12⟩ + (0.139+0.1i)|13⟩

julia> psi1 = basisstate(basis, 1)
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = |0⟩

julia> psi2 = sigmax(basis) * psi1
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = |1⟩

julia> plus = 1/sqrt(2) * (psi1 + psi2)
Ket(dim=2)
  basis: Spin(1/2)
|State⟩ = 0.707|0⟩ + 0.707|1⟩

julia> bell = (dm(psi1) ⊗ one(basis) + dm(psi2) ⊗ sigmax(basis)) * (plus ⊗ psi1)
Ket(dim=4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
|State⟩ = 0.707|00⟩ + 0.707|11⟩

julia> dm(bell)
DenseOperator(dim=4x4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
State = 0.5 |00⟩⟨00| +0.5 |00⟩⟨11| +0.5 |11⟩⟨00| +0.5 |11⟩⟨11|
```


### change the default state name
```julia
julia> DiracNotation.set_properties(statename="ψ")

julia> bell
Ket(dim=4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
|ψ⟩ = 0.707|00⟩ + 0.707|11⟩
```

### Display a state with arbitrary state name.
```julia
julia> dirac(psi1, "ϕ") # display state with arbitrary state name.
Ket(dim=2)
  basis: Spin(1/2)
|ϕ⟩ = |0⟩

julia> ρAB = dm(psi1) ⊗ dm(psi2);

julia> dirac(ρAB, "ρAB")
DenseOperator(dim=4x4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
ρAB = |01⟩⟨01|

julia> ρB = ptrace(ρAB, 1);

julia> dirac(ρB, "ρB")
DenseOperator(dim=2x2)
  basis: Spin(1/2)
ρB = |1⟩⟨1|
```

### Restore to original style
```julia
julia> DiracNotation.set_properties(isdiracstyle=false)

julia> bell
Ket(dim=4)
  basis: [Spin(1/2) ⊗ Spin(1/2)]
 0.707107+0.0im
      0.0+0.0im
      0.0+0.0im
 0.707107+0.0im
```


## Example on IJulia
On IJulia, Dirac notation is rendered by MathJax.  
- [QuantumOptics version](https://nbviewer.jupyter.org/github/goropikari/DiracNotation.jl/blob/master/examples/QuantumOptics.ipynb)
- [DiracNotation version](https://nbviewer.jupyter.org/github/goropikari/DiracNotation.jl/blob/master/examples/braket.ipynb)
