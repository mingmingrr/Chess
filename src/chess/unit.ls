require! './position.js' : Pos

export spawn = (types) ->

export kill = (piece, position, target, board) ->
	Pos.set null, board <| Pos.add position, target
	return board

export move = (piece, position, target, board) ->
	Pos.set piece, board <| Pos.add position, target
	Pos.set null, board, position
	return board

export promote = (types) ->
	throw new Error 'undefined promotion types' unless types?
	(piece, position, target, board) ->
		...


