require! './position.js': Pos

export count = (func) ->
	not-empty = empty false, offset
	(piece, position, target, board) ->
		not-empty ... and func do
			(.count) <| Pos.at board <| Pos.add position.target

export type = (func) ->
	not-empty = empty false, offset
	(piece, position, target, board) ->
		not-empty ... and func do
			(.type) <| Pos.at board <| Pos.add position, target

export team = (func) ->
	not-empty = empty false, offset
	(piece, position, target, board) ->
		not-empty ... and func piece.team do
			(.team) <| Pos.at board <| Pos.add position, target

export empty = (func) ->
	func = switch func | true => (==null) | false => (!=null) | otherwise => func
	(piece, position, target, board) ->
		func <| Pos.at board <| Pos.add position, target

export safe = (func) ->
	func = switch func | true => (not in) | false => (in) | otherwise => func
	(piece, position, target, board) ->
		func Piece.team do
			(.danger) <| Pos.at board <| Pos.add position, target

export row = (func) ->
	(piece, position, target, board) ->
		func <| (.1) <| Pos.add position, target
	
