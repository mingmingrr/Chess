require! '../unit.js': Unit
require! '../condition.js': Cond
require! '../symmetry.js': Sym

export symbols = <[\u2655 \u265b]>
export actions = Sym.sym8 <| concat-map _, [1 to 7] <| ->
	* 
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
			...
	* 
		danger: true
		target: [it, it]
		conds:
			* 
				target: [it, it]
				func: (not) . Cond.team (==)
			...map _, [1 til it] <| ->
				target: [it, it]
				func: Cond.empty true
		units:
			* 
				target: [it, it]
				func: Unit.move
			...
