export symbols = <[\u2654 \u265a]>
export moves =
	[[-1, -1]]
	[[-1, 0]]
	[[-1, 1]]
	[[0, -1]]
	[[0, 1]]
	[[1, -1]]
	[[1, 0]]
	[[1, 1]]
export takes = moves
export premoves =
	(board, [x, y]) -> # castle king side
		return null unless count == 0 and
			board.0.4 instanceof King and
			all (==null), board.0[5 to 6] and
			board.0.7 instanceof Rook and
			board.0.7.count == 0
		board = map (-> ^^it), board
		# TODO king checks
		[board.0.5, board.0.6] = [board.0.7, board.0.4]
		[board.0.7, board.0.4] = [null, null]
		return board
	(board, [x, y]) -> # castle queen side
		return null unless count == 0 and
			board.0.4 instanceof King and
			all (==null), board.0[1 to 3] and
			board.0.0 instanceof Rook and
			board.0.0.count == 0
		board = map (-> ^^it), board
		# TODO king checks
		[board.0.3, board.0.2] = [board.0.0, board.0.4]
		[board.0.0, board.0.4] = [null, null]
		return board
