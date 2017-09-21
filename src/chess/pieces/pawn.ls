require! '../unit.js': Unit
require! '../condition.js': Cond
require! '../symmetry.js': Sym

export symbols = <[\u2659 \u265f]>
export actions =
	* # intial move
		danger: false
		target: [0, 2]
		conds:
			* 
				target: [0, 0]
				func: Cond.count (==0)
			* 
				target: [0, 1]
				func: Cond.empty true
			* 
				target: [0, 2]
				func: Cond.empty true
		units:
			* 
				target: [0, 2]
				func: Unit.move
				conds: []
			...
	* # regular move
		danger: false
		target: [0, 1]
		conds:
			* 
				target: [0, 1]
				func: Cond.empty true
			...
		units:
			* 
				target: [0, 1]
				func: Unit.move
				conds: []
			* 
				target: [0, 1]
				func: Unit.spawn <| map do
					-> require "./#it.js"
					<[queen knight rook bishop]>
				conds:
					* 
						target: [0, 1]
						func: Cond.row (==7)
					...
	...Sym.sym2 (-> &) do
		* # diagonal attack
			danger: true
			target: [1, 1]
			conds:
				* 
					target: [1, 1]
					func: Cond.team (!=)
				...
			units:
				* 
					target: [1, 1]
					func: Unit.move
					conds: []
				* 
					target: [1, 1]
					func: Unit.spawn <| map do
						-> require "./#it.js"
						<[queen knight rook bishop]>
					conds:
						* 
							target: [0, 1]
							func: Cond.row (==7)
						...
		* # en passant
			danger: true
			target: [1, 0]
			conds:
				* 
					target: [0, 0]
					func: Cond.count (==2)
				* 
					target: [1, 1]
					func: Cond.empty true
				* 
					target: [0, 0]
					func: Cond.row (==4)
				* 
					target: [1, 0]
					func: Cond.type (==require './pawn.js')
				* 
					target: [1, 0]
					func: Cond.count (==1)
			units:
				* 
					target: [1, 0]
					func: Unit.kill
					conds: []
				* 
					target: [1, 1]
					func: Unit.move
					conds: []
