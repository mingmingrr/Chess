/*

Board :: [[Piece]]

Position :: [Int, Int]

Team :: Int

Piece :: {
	type :: Type
	team :: Team
	count :: Int
	danger :: [Team]
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
	func :: Piece -> Position -> Position -> Board -> Bool
}

Unit :: {
	target :: Position
	conds :: [Condition] = []
	func :: Piece -> Position -> Position -> Board -> Board
}

*/
