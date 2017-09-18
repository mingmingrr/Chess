export symbols = <[\u2659 \u265f]>
export moves =
	[[0, 1]]
	...
export takes =
	[[-1, 1]]
	[[1, 1]]
export premoves =
	(board, [x, y]) -> # initial double move
		return null unless @count == 0 and y == 1
		board = map (-> ^^it), board
		board.4[x] = board.2[x]
		board.2[x] = null
		return board
	(board, [x, y]) -> # en passant left side
		return null unless @count == 2 and
			y == 4 and x != 0 and
			board.5[x - 1] is null and
			board.4[x - 1] instanceof Pawn and
			board.4[x - 1].team != @team and
			board.4[x - 1].count == 1
		board = map (-> ^^it), board
		board.4[x - 1] = null
		board.5[x - 1] = board.4[x]
		board.4[x] = null
		return board
	(board, [x, y]) -> # en passant right side
		return null unless @count == 2 and
			y == 4 and x != 7 and
			board.5[x + 1] is null and
			board.4[x + 1] instanceof Pawn and
			board.4[x + 1].team != @team and
			board.4[x + 1].count == 1
		board = map (-> ^^it), board
		board.4[x + 1] = null
		board.5[x + 1] = board.4[x]
		board.4[x] = null
		return board
export postmoves =
	(board, [x, y]) ->
		return null unless y == 7
		piece = null
		while not piece
			piece = pieces [prompt 'Promote pawn to...']
			try
				throw new Error! unless piece
				piece = new piece @team
				throw new Error! if piece instanceof [Pawn, King]
			catch
				piece = null
		board = map (-> ^^it), board
		board.7[x] = piece
		return board
	...
