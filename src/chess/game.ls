require! './position.js': Pos

export find-action = (position, target, board) ->
	find (Pos.eq target) << (.target), (board `Pos.at` position).type.actions

export satisfies-conds = (board, position, conds) ->
	all _, conds <| (cond) ->
		return (Pos.bounded8 <| Pos.add position, cond.target) and
			cond.func position, cond.target, board

export valid = (position, target, board) ->
	action = find-action ...
	action? and satisfies-conds board, position, action.conds

export valids = (board, position) ->
	filter _, (Pos.at board, position).type.actions <| (action) ->
		satisfies-conds board, position, action.conds

export move = (position, target, board) ->
	action = find-action ...
	fold _, board, action.units <| (board, unit) ->
		if satisfies-conds board, position, unit.conds
			then unit.func position, unit.target, board
			else board

export dangers = (board) ->
	for pieces, y in board
		for piece, x in pieces
			if piece is not null
				valids board, [x, y]
				|> filter (.danger)
				|> map -> Pos.add [x, y], it.target
	|> concat

export flip-board = ({team, board}:state) ->
	state.board = reverse board if team == 1
	return state

export flip-team = ({team}:state) ->
	state.team = 1 - team
	return state
