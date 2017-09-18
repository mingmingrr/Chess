export add = zip-with (+)

export sub = zip-with (-)

export at = (board, [x, y]) -->
	board[y][x]

export set = (value, board, [x, y]) -->
	board[y][x] = value

