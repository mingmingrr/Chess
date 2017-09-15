window <<< require 'prelude-ls'

trace = -> console.log it; it

class Piece
	(@team, @count=0) ->
	@symbols = 'XY'
	@moves = [] # 3d array of available moves
	@takes = [] # 3d array of available taking moves
	@premoves = [] # special moves
	@postmoves = [] # special moves

class Pawn extends Piece
	@symbols = '♙♟'
	@moves =
		[[0, 1]]
		...
	@takes =
		[[-1, 1]]
		[[1, 1]]
	@premoves =
		(board, [x, y]) -> # initial double move
			return null unless @count == 0 and y == 1
			board = map (-> ^^it), board
			board.4[x] = board.2[x]
			board.2[x] = null
			return board
		(board, [x, y]) -> # en passant left side
			return null unless @count == 2 and
				y == 4 and x != 0 and
				board.5[x - 1] is null and
				board.4[x - 1] instanceof Pawn and
				board.4[x - 1].team != @team and
				board.4[x - 1].count == 1
			board = map (-> ^^it), board
			board.4[x - 1] = null
			board.5[x - 1] = board.4[x]
			board.4[x] = null
			return board
		(board, [x, y]) -> # en passant right side
			return null unless @count == 2 and
				y == 4 and x != 7 and
				board.5[x + 1] is null and
				board.4[x + 1] instanceof Pawn and
				board.4[x + 1].team != @team and
				board.4[x + 1].count == 1
			board = map (-> ^^it), board
			board.4[x + 1] = null
			board.5[x + 1] = board.4[x]
			board.4[x] = null
			return board
	@postmoves =
		(board, [x, y]) ->
			return null unless y == 7
			piece = null
			while not piece
				piece = prompt 'Promote pawn to...'
				try
					throw new Error! unless /^[A-Z][a-z]+$/.test piece
					piece = eval "new #piece(#{@team})"
					throw new Error! unless piece instanceof Piece
					throw new Error! if piece instanceof [Pawn, King]
				catch
					piece = null
			board = map (-> ^^it), board
			board.7[x] = piece
			return board
		...

class Rook extends Piece
	@symbols = '♖♜'
	@moves =
		map (-> [it, 0]), [1 to 7]
		map (-> [0, it]), [1 to 7]
		map (-> [it, 0]), [-1 to -7 by -1]
		map (-> [0, it]), [-1 to -7 by -1]
	@takes = @@moves

class Knight extends Piece
	@symbols = '♘♞'
	@moves =
		[[1, 2]]
		[[2, 1]]
		[[-1, 2]]
		[[-2, 1]]
		[[1, -2]]
		[[2, -1]]
		[[-1, -2]]
		[[-2, -1]]
	@takes = @@moves

class Bishop extends Piece
	@symbols = '♗♝'
	@moves =
		map (-> [it, it]), [1 to 7]
		map (-> [it, -it]), [1 to 7]
		map (-> [-it, it]), [1 to 7]
		map (-> [-it, -it]), [1 to 7]
	@takes = @@moves

class Queen extends Piece
	@symbols = '♕♛'
	@moves = Rook.moves ++ Bishop.moves
	@takes = @@moves

class King extends Piece
	@symbols = '♔♚'
	@moves =
		[[-1, -1]]
		[[-1, 0]]
		[[-1, 1]]
		[[0, -1]]
		[[0, 1]]
		[[1, -1]]
		[[1, 0]]
		[[1, 1]]
	@takes = @@moves
	@premoves =
		(board, [x, y]) -> # castle king side
			return null unless @count == 0 and
				board.0.4 instanceof King and
				all (==null), board.0[5 to 6] and
				board.0.7 instanceof Rook and
				board.0.7.count == 0
			board = map (-> ^^it), board
			# TODO king checks
			[board.0.5, board.0.6] = [board.0.7, board.0.4]
			[board.0.7, board.0.4] = [null, null]
			return board
		(board, [x, y]) -> # castle queen side
			return null unless @count == 0 and
				board.0.4 instanceof King and
				all (==null), board.0[1 to 3] and
				board.0.0 instanceof Rook and
				board.0.0.count == 0
			board = map (-> ^^it), board
			# TODO king checks
			[board.0.3, board.0.2] = [board.0.0, board.0.4]
			[board.0.0, board.0.4] = [null, null]
			return board

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

game = new Game do
	document.query-selector-all '#board tr'
	|> map (.query-selector-all \.cell)
	|> filter (.length) |> reverse
