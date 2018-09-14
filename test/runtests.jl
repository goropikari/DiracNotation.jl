using Test, DiracNotation, Random
Random.seed!(0)

# sprint(dirac, ρ)
# sprint(io -> dirac(IOContext(io, :compact=>true), ρ))
# sprint(io -> dirac(IOContext(io, :compact=>false), ρ))
# sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2]))
# sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2], "ϕ"))

ket = rand(4)
bra = ket'
ρ = rand(4,4)

DiracNotation.reset_properties()
@test sprint(dirac, ket) == "|ψ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩+0.177329|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket)) == "|ψ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩+0.177329|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), ket)) == "|ψ⟩ = 0.8236475079774124|00⟩+0.9103565379264364|01⟩+0.16456579813368521|10⟩+0.17732884646626457|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2])) == "|ψ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩+0.177329|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2], "ϕ")) == "|ϕ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩+0.177329|11⟩\n"

DiracNotation.set_properties(newline=true)
@test sprint(dirac, ket) == "|ψ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩\n     +0.177329|11⟩\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket)) == "|ψ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩\n     +0.177329|11⟩\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>false), ket)) == "|ψ⟩ = 0.8236475079774124|00⟩\n     +0.9103565379264364|01⟩\n     +0.16456579813368521|10⟩\n     +0.17732884646626457|11⟩\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2])) == "|ψ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩\n     +0.177329|11⟩\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2], "ϕ")) == "|ϕ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩\n     +0.177329|11⟩\n     "

DiracNotation.reset_properties()
DiracNotation.set_properties(precision=2)
@test sprint(dirac, ket) == "|ψ⟩ = 0.82|00⟩+0.91|01⟩+0.16|10⟩+0.18|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket)) == "|ψ⟩ = 0.82|00⟩+0.91|01⟩+0.16|10⟩+0.18|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), ket)) == "|ψ⟩ = 0.82|00⟩+0.91|01⟩+0.16|10⟩+0.18|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2])) == "|ψ⟩ = 0.82|00⟩+0.91|01⟩+0.16|10⟩+0.18|11⟩\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2], "ϕ")) == "|ϕ⟩ = 0.82|00⟩+0.91|01⟩+0.16|10⟩+0.18|11⟩\n"

DiracNotation.reset_properties()
DiracNotation.set_properties(displayall=false, numhead=3)
sprint(dirac, ket) == "|ψ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩ +...\n"
sprint(io -> dirac(IOContext(io, :compact=>true), ket)) == "|ψ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩ +...\n"
sprint(io -> dirac(IOContext(io, :compact=>false), ket)) == "|ψ⟩ = 0.8236475079774124|00⟩+0.9103565379264364|01⟩+0.16456579813368521|10⟩ +...\n"
sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2])) == "|ψ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩ +...\n"
sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2], "ϕ")) == "|ϕ⟩ = 0.823648|00⟩+0.910357|01⟩+0.164566|10⟩ +...\n"

DiracNotation.reset_properties()
DiracNotation.set_properties(displayall=false, numhead=3, newline=true)
@test sprint(dirac, ket) == "|ψ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩ +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket)) == "|ψ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩ +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), ket)) == "|ψ⟩ = 0.8236475079774124|00⟩\n     +0.9103565379264364|01⟩\n     +0.16456579813368521|10⟩ +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2])) == "|ψ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩ +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ket, [2,2], "ϕ")) == "|ϕ⟩ = 0.823648|00⟩\n     +0.910357|01⟩\n     +0.164566|10⟩ +...\n"


DiracNotation.reset_properties()
@test sprint(dirac, bra) == "⟨ψ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10|+0.177329⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra)) == "⟨ψ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10|+0.177329⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), bra)) == "⟨ψ| = 0.8236475079774124⟨00|+0.9103565379264364⟨01|+0.16456579813368521⟨10|+0.17732884646626457⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2])) == "⟨ψ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10|+0.177329⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2], "ϕ")) == "⟨ϕ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10|+0.177329⟨11|\n"

DiracNotation.set_properties(newline=true)
@test sprint(dirac, bra) == "⟨ψ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10|\n     +0.177329⟨11|\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra)) == "⟨ψ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10|\n     +0.177329⟨11|\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>false), bra)) == "⟨ψ| = 0.8236475079774124⟨00|\n     +0.9103565379264364⟨01|\n     +0.16456579813368521⟨10|\n     +0.17732884646626457⟨11|\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2])) == "⟨ψ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10|\n     +0.177329⟨11|\n     "
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2], "ϕ")) == "⟨ϕ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10|\n     +0.177329⟨11|\n     "

DiracNotation.reset_properties()
DiracNotation.set_properties(precision=2)
@test sprint(dirac, bra) == "⟨ψ| = 0.82⟨00|+0.91⟨01|+0.16⟨10|+0.18⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra)) == "⟨ψ| = 0.82⟨00|+0.91⟨01|+0.16⟨10|+0.18⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), bra)) == "⟨ψ| = 0.82⟨00|+0.91⟨01|+0.16⟨10|+0.18⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2])) == "⟨ψ| = 0.82⟨00|+0.91⟨01|+0.16⟨10|+0.18⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2], "ϕ")) == "⟨ϕ| = 0.82⟨00|+0.91⟨01|+0.16⟨10|+0.18⟨11|\n"

DiracNotation.reset_properties()
DiracNotation.set_properties(displayall=false, numhead=3)
sprint(dirac, bra) == "⟨ψ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10| +...\n"
sprint(io -> dirac(IOContext(io, :compact=>true), bra)) == "⟨ψ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10| +...\n"
sprint(io -> dirac(IOContext(io, :compact=>false), bra)) == "⟨ψ| = 0.8236475079774124⟨00|+0.9103565379264364⟨01|+0.16456579813368521⟨10| +...\n"
sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2])) == "⟨ψ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10| +...\n"
sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2], "ϕ")) == "⟨ϕ| = 0.823648⟨00|+0.910357⟨01|+0.164566⟨10| +...\n"

DiracNotation.reset_properties()
DiracNotation.set_properties(displayall=false, numhead=3, newline=true)
@test sprint(dirac, bra) == "⟨ψ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra)) == "⟨ψ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), bra)) == "⟨ψ| = 0.8236475079774124⟨00|\n     +0.9103565379264364⟨01|\n     +0.16456579813368521⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2])) == "⟨ψ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), bra, [2,2], "ϕ")) == "⟨ϕ| = 0.823648⟨00|\n     +0.910357⟨01|\n     +0.164566⟨10| +...\n"





DiracNotation.reset_properties()
@test sprint(dirac, ρ) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|+0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|+0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|+0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ)) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|+0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|+0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|+0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), ρ)) == "ρ = 0.278880109331201|00⟩⟨00|+0.3618283907762174|00⟩⟨01|+0.26003585026904785|00⟩⟨10|+0.5758873948500367|00⟩⟨11|+0.20347655804192266|01⟩⟨00|+0.9732164043865108|01⟩⟨01|+0.910046541351011|01⟩⟨10|+0.8682787096942046|01⟩⟨11|+0.042301665932029664|10⟩⟨00|+0.5858115517433242|10⟩⟨01|+0.16703619444214968|10⟩⟨10|+0.9677995536192001|10⟩⟨11|+0.06826925550564478|11⟩⟨00|+0.5392892841426182|11⟩⟨01|+0.6554484126999125|11⟩⟨10|+0.7676903325581188|11⟩⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2])) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|+0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|+0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|+0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2], "ϕ")) == "ϕ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|+0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|+0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|+0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n"

DiracNotation.reset_properties()
DiracNotation.set_properties(newline=true)
@test sprint(dirac, ρ) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|\n   +0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|\n   +0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|\n   +0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n   "
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ)) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|\n   +0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|\n   +0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|\n   +0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n   "
@test sprint(io -> dirac(IOContext(io, :compact=>false), ρ)) == "ρ = 0.278880109331201|00⟩⟨00|+0.3618283907762174|00⟩⟨01|+0.26003585026904785|00⟩⟨10|+0.5758873948500367|00⟩⟨11|\n   +0.20347655804192266|01⟩⟨00|+0.9732164043865108|01⟩⟨01|+0.910046541351011|01⟩⟨10|+0.8682787096942046|01⟩⟨11|\n   +0.042301665932029664|10⟩⟨00|+0.5858115517433242|10⟩⟨01|+0.16703619444214968|10⟩⟨10|+0.9677995536192001|10⟩⟨11|\n   +0.06826925550564478|11⟩⟨00|+0.5392892841426182|11⟩⟨01|+0.6554484126999125|11⟩⟨10|+0.7676903325581188|11⟩⟨11|\n   "
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2])) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|\n   +0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|\n   +0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|\n   +0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n   "
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2], "ϕ")) == "ϕ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10|+0.575887|00⟩⟨11|\n   +0.203477|01⟩⟨00|+0.973216|01⟩⟨01|+0.910047|01⟩⟨10|+0.868279|01⟩⟨11|\n   +0.0423017|10⟩⟨00|+0.585812|10⟩⟨01|+0.167036|10⟩⟨10|+0.9678|10⟩⟨11|\n   +0.0682693|11⟩⟨00|+0.539289|11⟩⟨01|+0.655448|11⟩⟨10|+0.76769|11⟩⟨11|\n   "

DiracNotation.reset_properties()
DiracNotation.set_properties(displayall=false, numhead=3)
@test sprint(dirac, ρ) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ)) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>false), ρ)) == "ρ = 0.278880109331201|00⟩⟨00|+0.3618283907762174|00⟩⟨01|+0.26003585026904785|00⟩⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2])) == "ρ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10| +...\n"
@test sprint(io -> dirac(IOContext(io, :compact=>true), ρ, [2,2], [2,2], "ϕ")) == "ϕ = 0.27888|00⟩⟨00|+0.361828|00⟩⟨01|+0.260036|00⟩⟨10| +...\n"
