global import Prelude

require! './chess/game.js': Game
require! './chess/position.js': Pos
require! './chess/pieces/index.js': Pieces

trace = -> console.log it; it

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
		throw new Error 'invalid move' # for redundancy
	piece = state.board `Pos.at` position
	state.board = Game.move position, target, state.board
	piece.count += 1
	console.log \state, state
	return state

for ns, y in state.nodes
	for node, x in ns
		node.set-attribute \p, JSON.stringify [x, y]
		node.add-event-listener \dragover, !->
			it.prevent-default!
		node.add-event-listener \dragstart, !->
			it.data-transfer.set-data \text, do
				it.target.get-attribute \p
			position = JSON.parse it.target.get-attribute \p
		node.add-event-listener \drop, !->
			position = JSON.parse it.data-transfer.get-data \text
			target = Pos.sub _, position <| JSON.parse it.target.get-attribute \p
			state := move position, target, state |> sync

