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

move = (position, target, state) ->
	unless Game.valid position, target, state.board
		throw new Error 'invalid move'
	piece = state.board `Pos.at` position
	piece.count += 1
	state.board = Game.move position, target, state.board
	console.log \state, state
	return state

highlight = ({board, nodes}, position, css='valid') ->
	[{target:[0, 0]}] ++ Game.valids board, position
	|> map ({target}) !->
		Pos.at nodes, (Pos.add position, target) .class-list.add css
	return state

unhighlight = ({nodes}, css='valid') ->
	map _, nodes <| map -> it.class-list.remove css
	return state

for nodes, y in state.nodes
	for node, x in nodes
		node.set-attribute \p, JSON.stringify [x, y]

		node.add-event-listener \mouseover, !->
			position = JSON.parse it.target.get-attribute \p
			piece = state.board `Pos.at` position
			return unless piece? and piece.team == state.team
			highlight state, position
		node.add-event-listener \mouseout, !->
			unhighlight state

		node.add-event-listener \dragover, !->
			it.prevent-default!
		node.add-event-listener \dragstart, !->
			position = it.target.get-attribute \p
			it.data-transfer.set-data \text, position
		node.add-event-listener \drop, !->
			position = JSON.parse it.data-transfer.get-data \text
			target = Pos.sub _, position <| JSON.parse it.target.get-attribute \p
			return if Pos.eq target, [0, 0]
			state := state
			|> move position, target, _
			|> sync

