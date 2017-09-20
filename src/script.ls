require! 'prelude-ls': Prelude
global import Prelude

require! './chess/game.js': Game
require! './chess/position.js': Pos
require! './chess/pieces/index.js': Pieces

trace = -> console.log it; it

nodes = document.query-selector-all '.board .row'
|> map (.query-selector-all \.cell) |> reverse

board = [
	<[Rook Knight Bishop Queen King Bishop Knight Rook]>
	<[Pawn Pawn   Pawn   Pawn  Pawn Pawn   Pawn   Pawn]>
]
|> -> return
	...map _, it <| map ->
		type: Pieces[it]
		team: 0
		count: 0
		danger: []
	...map (-> [null] * 8), [til 4]
	...map _, reverse it <| map ->
		type: Pieces[it]
		team: 1
		count: 0
		danger: []
console.log \board, board

do sync = !->
	zip-with do
		zip-with !->
			&0.text-content = if &1?
				then &1.type.symbols[&1.team]
				else ''
		nodes
		board

for ns, row in nodes
	for node, col in ns
		node.set-attribute \p, JSON.stringify [col, row]
		node.add-event-listener \dragover, ->
			it.prevent-default!
		node.add-event-listener \dragstart, ->
			it.data-transfer.set-data \text, do
				it.target.get-attribute \p
		node.add-event-listener \drop, ->
			position = JSON.parse it.data-transfer.get-data \text
			target = Pos.sub _, position <| JSON.parse it.target.get-attribute \p
			piece = Pos.at board, position
			return unless Game.valid piece, position, target, board
			Game.move piece, position, target, board
			sync!
			console.log \board, board

console.log \queen, map (.target), Pieces.Queen.actions
console.log \king, map (.target), Pieces.King.actions
console.log \rook, map (.target), Pieces.Rook.actions

