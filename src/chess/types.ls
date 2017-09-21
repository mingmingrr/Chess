/*

Board :: [[Piece]]

Position :: [Int, Int]

Team :: Int

Piece :: {
	type :: Type
	team :: Team
	count :: Int
}

Type :: {
	symbols :: [String]
	actions :: [Action]
}

Action :: {
	danger :: Bool = true
	target :: Position
	conds :: [Condition]
	units :: [Unit]
}

Condition :: {
	target :: Position
	func :: Position -> Position -> Board -> Bool
}

Unit :: {
	target :: Position
	conds :: [Condition] = []
	func :: Position -> Position -> Board -> Board
}

*/
