require! './position.js': Pos

export find-action = (position, target, board) -->
	find (Pos.eq target) << (.target), (board `Pos.at` position).type.actions

export find-piece = (piece, board) -->
	board
	|> map (elem-index piece)
	|> zip [til 8]
	|> find (!=undefined) << (.1)
	|> reverse

export satisfies-conds = (board, position, conds) -->
	all _, conds <| (cond) ->
		return (Pos.bounded8 <| Pos.add position, cond.target) and
			cond.func position, cond.target, board

export valid = (position, target, board) -->
	action = find-action ...
	action? and satisfies-conds board, position, action.conds

export valids = (board, position) -->
	filter _, (Pos.at board, position).type.actions <| (action) ->
		satisfies-conds board, position, action.conds

export move = (position, target, board) -->
	action = find-action ...
	fold _, board, action.units <| (board, unit) ->
		if satisfies-conds board, position, unit.conds
			then unit.func position, unit.target, board
			else board

# export dangers = ({board}) ->
# 	for pieces, y in board
# 		for piece, x in pieces
# 			switch piece
# 			| null => continue
# 			| otherwise =>
# 				valids board, [x, y]
# 				|> filter (.danger)
# 				|> map -> Pos.add [x, y], it.target
# 	|> concat

export flip-board = ({team, board}:state) ->
	state.board = reverse board
	return state

export flip-nodes = ({team, nodes}:state) ->
	state.nodes = reverse nodes
	return state

export flip-team = ({team}:state) ->
	state.team = 1 - team
	return state

export flip-all = flip-board << flip-nodes << flip-team

export flip-position = ({team}, [x, y]) -->
	if team == 1 then [x, -y] else [x, y]

export enum-with = (func, board) -->
	for ps, y in board
		for p, x in ps
			func board, [x, y]
