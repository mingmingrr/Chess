require! './position.js' : Pos

export spawn = (types, get-type=null, carry-count=true) ->
	(piece, position, target, board) ->
		type = if Array.is-array types then get-type types else types
		count = if carry-count then piece.count else 0
		Pos.set _, board, Pos.add position, target
			<| {} <<< piece <<< {type:type, count:count}
		return board

export kill = (piece, position, target, board) ->
	Pos.set null, board <| Pos.add position, target
	return board

export move = (piece, position, target, board) ->
	Pos.set piece, board <| Pos.add position, target
	Pos.set null, board, position
	return board

export yank = (direction) ->
	(piece, position, target, board) ->
		pos = Pos.add position, target
		Pos.set piece, board, <| Pos.add pos, direction
		Pos.set null, board, pos
		return board
