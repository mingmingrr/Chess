require! './position.js': Pos

export count = (func) ->
	(piece, position, target, board) ->
		func piece.count

export type = (func) ->
	(piece, position, target, board) ->
		func piece.type

export team = (func, offset=[0, 0]) ->
	not-empty = empty false, offset
	(piece, position, target, board) ->
		not-empty ... and func piece.team do
			(.team) <| Pos.at board <| Pos.add offset <| Pos.add position, target

export empty = (func, offset=[0, 0]) ->
	func = switch func | true => (==null) | false => (==null) | otherwise => func
	(piece, position, target, board) ->
		func <| Pos.at board <| Pos.add offset <| Pos.add position, target



