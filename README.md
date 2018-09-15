# DiracNotation

[![Build Status](https://travis-ci.org/goropikari/DiracNotation.jl.svg?branch=master)](https://travis-ci.org/goropikari/DiracNotation.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/fjmycb3eua297348?svg=true)](https://ci.appveyor.com/project/goropikari/diracnotation-jl)
[![Coverage Status](https://coveralls.io/repos/goropikari/DiracNotation.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/goropikari/DiracNotation.jl?branch=master)
[![codecov.io](http://codecov.io/github/goropikari/DiracNotation.jl/coverage.svg?branch=master)](http://codecov.io/github/goropikari/DiracNotation.jl?branch=master)

By using this package, matrix representation is changed into Dirac notation.
This package supports for [QuantumOptics.jl](https://github.com/qojulia/QuantumOptics.jl)
## Installation
```julia
using Pkg
Pkg.pkg"add https://github.com/goropikari/DiracNotation.jl"
```

## Usage
### Simple example
```julia
julia> using DiracNotation, LinearAlgebra, Random; Random.seed!(0);

julia> ket = normalize(rand(4)); bra = ket';

julia> dirac(ket) # if the dimension of state is power of 2 ( 2^n ), it is interpreted as n-qubit system.
|ψ⟩ = 0.658|00⟩+0.728|01⟩+0.132|10⟩+0.142|11⟩

julia> dirac(bra)
⟨ψ| = 0.658⟨00|+0.728⟨01|+0.132⟨10|+0.142⟨11|

julia> DiracNotation.set_properties(precision=3)

julia> op = rand(2,2);

julia> leftdims = [2];

julia> rightdims = [2];

julia> dirac(op, leftdims, rightdims)
ρ = 0.279|0⟩⟨0|+0.0423|0⟩⟨1|+0.203|1⟩⟨0|+0.0683|1⟩⟨1|

julia> DiracNotation.set_properties(numhead=10, displayall=false)

julia> op = rand(6,4);

# if the state is not qubits system, you have to specify the dimension of domain and codomain explicitly.
julia> dirac(op, [2,3], [2,2])
ρ = 0.362|00⟩⟨00|+0.167|00⟩⟨01|+0.469|00⟩⟨10|+0.0668|00⟩⟨11|+0.973|01⟩⟨00|+0.655|01⟩⟨01|+0.0624|01⟩⟨10|+0.157|01⟩⟨11|+0.586|02⟩⟨00|+0.576|02⟩⟨01| +...
```


### Display a state with arbitrary state name.
```julia
julia> dirac(ket, "ϕ")
|ϕ⟩ = 0.658|00⟩+0.728|01⟩+0.132|10⟩+0.142|11⟩

julia> dirac(op, "A")
A = 0.279|0⟩⟨0|+0.0423|0⟩⟨1|+0.203|1⟩⟨0|+0.0683|1⟩⟨1|
```

### Restore to original style
```julia
DiracNotation.reset_properties()
dirac(ket, "ϕ")
dirac(op, "A")

julia> DiracNotation.reset_properties()

julia> dirac(ket, "ϕ")
|ϕ⟩ = 0.65825|00⟩+0.727547|01⟩+0.131519|10⟩+0.141719|11⟩

julia> dirac(op, "A")
A = 0.27888|0⟩⟨0|+0.0423017|0⟩⟨1|+0.203477|1⟩⟨0|+0.0682693|1⟩⟨1|
```


## Example on IJulia
On IJulia, Dirac notation is rendered as MathJax.

![mathjax](examples/mathjax.png)
- [Example](./examples/example.ipynb)
