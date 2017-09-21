export add = zip-with (+)

export sub = zip-with (-)

export at = (board, [x, y]) -->
	board[y][x]

export set = (value, board, [x, y]) -->
	board[y][x] = value

export eq = ([x1, y1], [x2, y2]) -->
	x1 == x2 and y1 == y2

export bounded = (min, max, position) -->
	and-list <| zip-all-with _, min, position, max <| (a, b, c) -> a <= b < c

export bounded8 = bounded [0, 0], [8, 8]

