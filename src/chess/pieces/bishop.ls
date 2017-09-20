require! '../unit.js': Unit
require! '../condition.js': Cond
require! '../symmetry.js': Sym

export symbols = <[\u2657 \u265d]>
export actions = Sym.sym8 <| map _, [1 to 7] <| ->
	danger: true
	target: [it, it]
	conds:
		* 
			target: [it, it]
			func: (not) . Cond.team (==)
		...map _, [1 til it] <| ->
			target: [it, it]
			func: Cond.empty true
		...
	units:
		* 
			target: [it, it]
			func: Unit.move
			conds: []
		...

