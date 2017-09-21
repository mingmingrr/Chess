require! './game.js': Game
require! './position.js': Pos

export count = (func) ->
	not-empty = empty false
	(position, target, board) ->
		not-empty ... and func do
			(.count) <| Pos.at board <| Pos.add position, target

export type = (func) ->
	not-empty = empty false
	(position, target, board) ->
		not-empty ... and func do
			(.type) <| Pos.at board <| Pos.add position, target

export team = (func) ->
	not-empty = empty false
	(position, target, board) ->
		not-empty ... and func (Pos.at board, position).team, do
			(.team) <| Pos.at board <| Pos.add position, target

export empty = (func) ->
	func = switch func | true => (==null) | false => (!=null) | otherwise => func
	(position, target, board) ->
		func <| Pos.at board <| Pos.add position, target

export safe = (func) ->
	func = switch func | true => (not in) | false => (in) | otherwise => func
	(position, target, board) ->
		func (Pos.at board, position).team, do
			(.danger) <| Pos.at board <| Pos.add position, target

export row = (func) ->
	(position, target, board) ->
		func <| (.1) <| Pos.add position, target
	
