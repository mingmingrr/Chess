require! 'prelude-ls': Prelude
global import Prelude

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
			return unless &1
			&0.text-content = &1.type.symbols[&1.team]
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
			target = JSON.parse it.target.get-attribute \p
			alert (JSON.stringify position) + (JSON.stringify target)

