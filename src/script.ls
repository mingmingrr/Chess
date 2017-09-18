window <<< require 'prelude-ls'

trace = -> console.log it; it

move-by = ([x1, y1], [x2, y2]) -->
	[x1 + x2, y1 + y2]

all-cond = (fs, x) -->
	all (-> it x), fs

class Game
	(@nodes, @board=null) ->
		if @board is null
			@board =
				[Pawn , Pawn   , Pawn   , Pawn  , Pawn , Pawn   , Pawn   , Pawn]
				[Rook , Knight , Bishop , Queen , King , Bishop , Knight , Rook]
		if @board.length == 2
			@board =
				(map (map -> new it 0), (reverse @board)) ++
				(map (-> [null] * 8), [til 4]) ++
				(map (map -> new it 1), @board)
		map _, @nodes <| map (n) ->
			[x, y] = JSON.parse n.get-attribute \p
			n.add-event-listener \dragover, (event) !->
				event.prevent-default!
			n.add-event-listener \dragstart, (event) !->
				console.log \dragstart, event
			n.add-event-listener \drop, (event) !->
				console.log \drop, event
		@update!
	update: ->
		zip-with do
			zip-with ->
				if &1
					then &0.text-content = &1.@@symbols[&1.team]
					else ''
			@nodes
			@board
		return @
	move: ([xi, yi], [x, y]) -->
		[x, y] = [xi + x, yi + y]
		return null unless @board[y][x] is null
		[@board[yi][xi], @board[y][x]] = [null, @board[yi][xi]]
		return @
	take: ([xi, yi], [x, y]) -->
		[x, y] = [xi + x, yi + y]
		return null unless @board[y][x] is not null or
			@board[y][x].team != @board[yi][xi].team
		[@board[yi][xi], @board[y][x]] = [null, @board[yi][xi]]
		return @
	empty: ([x, y]) ->
		@board[y][x] == null
	bounded: ([x, y]) ->
		0 <= x < 8 and 0 <= y < 8
	piece-at: ([x, y]) ->
		@board[y][x]
	friendly: ([x1, y1], [x2, y2]) -->
		(==) `over` ((.team) << @piece-at)
	moves: ([xi, yi]) ->
		concat-map do
			take-while <| all-cond [@bounded, @empty . move-by [xi, yi]]
			@board[yi][xi].@@moves
	takes: ([xi, yi]) ->
		filter do
			all-cond [@bounded, (not) . @empty, (not) . @friendly [xi, yi]] .
			move-by [xi, yi]
		<| map do
			head << drop-while << all-cond @bounded, @empty . move-by [xi, yi]
			@board[yi][xi].@@takes
	attacks: ([xi, yi]) ->
		(++) do
			concat-map do
				take-while <| all-cond [@bounded, @empty . move-by [xi, yi]]
				@board[yi][xi].@@takes
			@attacks [xi, yi]
	all-attacks: (team) ->
		s = new Set!
		for y til @board.length
			for x til @board.0.length
				continue unless @piece-at [x, y] .team == team
				each do
					set.add . JSON.stringify . move-by [x, y]
					@attacks [x, y]
		return s

game = new Game do
	document.query-selector-all '#board tr'
	|> map (.query-selector-all \.cell)
	|> filter (.length) |> reverse
