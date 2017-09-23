global import Prelude

require! './chess/game.js': Game
require! './chess/position.js': Pos
require! './chess/pieces/index.js': Pieces

trace = -> console.log it; it

window.get-type = (types) ->
	types[parse-int prompt ((map (.symbols), types) * ', ')]

state =
	nodes: document.query-selector-all '.board .row'
		|> map (.query-selector-all \.cell) |> reverse

	board: [
			<[Rook Knight Bishop Queen King Bishop Knight Rook]>
			<[Pawn Pawn   Pawn   Pawn  Pawn Pawn   Pawn   Pawn]>
	] |> -> return
		...map _, it <| map ->
			type: Pieces[it]
			team: 0
			count: 0
		...map (-> [null] * 8), [til 4]
		...map _, reverse it <| map ->
			type: Pieces[it]
			team: 1
			count: 0
	danger: map (-> map (-> []), [til 8]), [til 8]
	last: []
	team: 0
console.log \state, state

sync = (state) ->
	zip-with do
		zip-with !->
			[&0.text-content, drag] = switch
			| not &1? => ['', false]
			| ((==) `over` (.team)) state, &1 => [&1.type.symbols[&1.team], true]
			| otherwise => [&1.type.symbols[&1.team], false]
			&0.set-attribute \draggable, drag
		state.nodes
		state.board
	return state
state = sync state
window.state = state

move = (position, target, state) ->
	unless Game.valid position, target, state.board
		throw new Error 'invalid move'
	Pos.at state.board, position .count += 1
	Pos.at state.nodes, position .class-list.add \last
	Pos.at state.nodes, (Pos.add position, target) .class-list.add \last
	state.board = Game.move position, target, state.board
	console.log \state, state
	return state

highlight = ({board, nodes}, position, css='valid') ->
	[{target:[0, 0]}] ++ Game.valids board, position
	|> map ({target}) !->
		Pos.at nodes, (Pos.add position, target) .class-list.add css
	return state

unhighlight = ({nodes}, css=\valid) ->
	map _, nodes <| map -> it.class-list.remove css
	return state

for let ns, y in state.nodes
	for let node, x in ns
		node.add-event-listener \mouseover, !->
			piece = state.board `Pos.at` (Game.find-piece node, state.nodes)
			return unless piece? and piece.team == state.team
			highlight state, Game.find-piece node, state.nodes
		node.add-event-listener \mouseout, !->
			unhighlight state

		node.add-event-listener \dragover, (.prevent-default!)
		node.add-event-listener \dragstart, !->
			it.data-transfer.set-data 'application/json', do
				JSON.stringify Game.find-piece node, state.nodes
		node.add-event-listener \drop, !->
			position = JSON.parse it.data-transfer.get-data 'application/json'
			target = Game.find-piece node, state.nodes |> Pos.sub _, position
			return if Pos.eq target, [0, 0]
			state := state
			|> unhighlight _, \last
			|> move position, target, _
			|> Game.flip-all
			|> sync

