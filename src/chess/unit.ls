require! './position.js' : Pos

export spawn = (types, get-type=null, carry-count=true) ->
	(position, target, board) ->
		get-type ?= window.get-type
		position = Pos.add position, target
		type = if Array.is-array types then get-type types else types
		count = if carry-count
			then (board `Pos.at` position).count else 0
		Pos.set _, board, position
			<| {} <<< (board `Pos.at` position) <<< {type:type, count:count}
		return board

export kill = (position, target, board) ->
	Pos.set null, board <| Pos.add position, target
	return board

export move = (position, target, board) ->
	Pos.set (board `Pos.at` position), board <| Pos.add position, target
	Pos.set null, board, position
	return board

export yank = (direction) ->
	(position, target, board) ->
		pos = Pos.add position, target
		Pos.set (board `Pos.at` pos), board, <| Pos.add pos, direction
		Pos.set null, board, pos
		return board
