require! './position.js': Pos

export find-action = (piece, target) ->
	find (Pos.eq target) << (.target), piece.type.actions

export satisfies-conds = (board, position, conds) ->
	all _, conds <| (cond) ->
		return (Pos.bounded8 (Pos.add position, cond.target)) and
			cond.func (Pos.at board, position), position, cond.target, board

export valid = (piece, position, target, board) ->
	action = find-action piece, target
	action? and satisfies-conds board, position, action.conds

export valids = (board, position) ->
	filter _, (Pos.at board, position).type.actions <| (action) ->
		satisfies-conds board, position, action.conds

export move = (piece, position, target, board) ->
	throw new Error 'invalid move' unless valid ...
	action = find-action piece, target
	fold _, board, action.units <| (board, unit) ->
		if satisfies-conds board, position, unit.conds
			then unit.func piece, position, unit.target, board
			else board

