require! '../unit.js': Unit
require! '../condition.js': Cond
require! '../symmetry.js': Sym

export symbols = <[\u2658 \u265e]>
export actions = Sym.sym8 <| (-> &) do
	danger: true
	target: [1, 2]
	conds:
		* 
			target: [1, 2]
			func: (not) . Cond.team (==)
		...
	units:
		* 
			target: [1, 2]
			func: Unit.move
		...

