/*

Board :: [[Piece]]

Position :: [Int, Int]

Piece :: {
	type :: Type,
	count :: Int,
	team :: Int
}

Type :: {
	symbols :: [String],
	actions :: [Action]
}

Action :: {
	target :: Position,
	conds :: [Condition]
	units :: [Unit]
}

Condition :: {
	target :: Position,
	func :: Piece -> Position -> Position -> Board -> Bool
}

Unit :: {
	target :: Position,
	func :: Piece -> Position -> Position -> Board -> Board
}

*/
