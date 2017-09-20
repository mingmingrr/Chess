require! '../unit.js': Unit
require! '../condition.js': Cond
require! '../symmetry.js': Sym

export symbols = <[\u2656 \u265c]>
export actions = Sym.sym8 <| map _, [1 to 7] <| ->
	danger: true
	target: [it, 0]
	conds:
		* 
			target: [it, 0]
			func: (not) . Cond.team (==)
		...map _, [1 til it] <| ->
			target: [it, 0]
			func: Cond.empty true
	units:
		* 
			target: [it, 0]
			func: Unit.move
			conds: []
		...

