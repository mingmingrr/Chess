require! '../unit.js': Unit
require! '../condition.js': Cond
require! '../symmetry.js': Sym

export symbols = <[\u2654 \u265a]>
export actions =
	* # castling queen side
		danger: false
		target: [-2, 0]
		conds:
			* 
				target: [0, 0]
				func: Cond.count (==0)
			* 
				target: [-4, 0]
				func: Cond.count (==0)
			...map _, [-1 to -3 by -1] <| ->
				target: [it, 0]
				func: Cond.empty true
			# ...map _, [0 to -4 by -1] <| ->
			# 	target: [it, 0]
			# 	func: Cond.safe true
		units:
			* 
				target: [-2, 0]
				func: Unit.move
				conds: []
			* 
				target: [-4, 0]
				func: Unit.yank [3, 0]
				conds: []
	* # castling king side
		danger: false
		target: [2, 0]
		conds:
			* 
				target: [0, 0]
				func: Cond.count (==0)
			* 
				target: [3, 0]
				func: Cond.count (==0)
			...map _, [1 to 2] <| ->
				target: [it, 0]
				func: Cond.empty true
			# ...map _, [0 to 3] <| ->
			# 	target: [it, 0]
			# 	func: Cond.safe true
		units:
			* 
				target: [2, 0]
				func: Unit.move
				conds: []
			* 
				target: [3, 0]
				func: Unit.yank [-2, 0]
				conds: []
	...Sym.sym8 [
		* # diagonal move
			danger: true
			target: [1, 1]
			conds:
				* 
					target: [1, 1]
					func: (not) . Cond.team (==)
				...
			units: 
				* 
					target: [1, 1]
					func: Unit.move
					conds: []
				...
		* # straight move
			danger: true
			target: [0, 1]
			conds:
				* 
					target: [0, 1]
					func: (not) . Cond.team (==)
				...
			units: 
				* 
					target: [0, 1]
					func: Unit.move
					conds: []
				...
		]
