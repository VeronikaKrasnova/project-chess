extends Node2D

var tile_size := 100
var board_origin := Vector2( 0, 0) # left top angle of board position 
var board_size := Vector2(8, 8)  # board size (8x8 cells)
var pawn_cell := Vector2i(2, 1) # pawn start position
var king_cell := Vector2i(3, 0) # king start position
var rook_cell := Vector2i(0, 0) # rook start position

var black_pawn_cell := Vector2i(4, 6)

enum PieceType { NONE, PAWN, KING, ROOK }
var selected_piece: PieceType = PieceType.NONE

var highlight_scene := preload("res://scenes/HighlightTile.tscn")
var highlights := []

var occupied_cells: Array[Vector2i] = []

var bot :  = preload("res://script/bot.gd").new()


# placing objects
func _ready():
	board_origin = $Board.position + Vector2(30, 30)  # got board position in px
	
	set_piece_to_cell($Pawn, pawn_cell)
	$Pawn.left_click.connect(on_pawn_left_click) # got pawn signal
	
	set_piece_to_cell($King, king_cell)
	$King.left_click.connect(on_king_left_click) # got king signal
	
	set_piece_to_cell($Rook, rook_cell)
	$Rook.left_click.connect(on_rook_left_click) # got king signal
	
	set_piece_to_cell($Black_Pawn, black_pawn_cell)
	
	bot = preload("res://script/bot.gd").new()



# coordinate marking on the board
func set_piece_to_cell(piece: Node2D, cell: Vector2i):
	var corrected_y = 7 - cell.y
	var cell_position = board_origin + Vector2(cell.x, corrected_y) * tile_size
	@warning_ignore("integer_division")
	piece.position = cell_position + Vector2(tile_size / 2, tile_size / 2)



#check empty cells
func update_occupied_cells():
	occupied_cells.clear()
	occupied_cells.append(pawn_cell)
	occupied_cells.append(king_cell)
	occupied_cells.append(rook_cell)
	occupied_cells.append(black_pawn_cell)


# move chosen piece to chosen cell
func on_tile_clicked(target_cell: Vector2i):
	match selected_piece:
		PieceType.PAWN:
			pawn_cell = target_cell
			set_piece_to_cell($Pawn, pawn_cell)
		PieceType.KING:
			king_cell = target_cell
			set_piece_to_cell($King, king_cell)
		PieceType.ROOK:
			rook_cell = target_cell
			set_piece_to_cell($Rook, rook_cell)
	selected_piece = PieceType.NONE
	clear_highlights()
	update_occupied_cells()
	bot_move()


# show posible pawn ways
func on_pawn_left_click():
	selected_piece = PieceType.PAWN
	clear_highlights()
	update_occupied_cells()
	
	var pawn_cell_1 := pawn_cell + Vector2i(0, 1)
	if is_cell_in_bounds(pawn_cell_1) and not is_cell_occupied(pawn_cell_1):
		add_highlight(pawn_cell_1)
	# if pawn in start position (y == 1)
	if pawn_cell.y == 1:
		var pawn_cell_2 := pawn_cell + Vector2i(0, 2)
		if not is_cell_occupied(pawn_cell_2) and not is_cell_occupied(pawn_cell_2):
			add_highlight(pawn_cell_2)

# show posible king ways
func on_king_left_click():
	selected_piece = PieceType.KING
	clear_highlights()
	update_occupied_cells()
	
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0),                  Vector2i(1, 0),
		Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1)
	]
	for dir in directions:
		var king_target_cell = king_cell + dir
		if is_cell_in_bounds(king_target_cell) and not is_cell_occupied(king_target_cell):
			add_highlight(king_target_cell)

# show posible rook ways
func on_rook_left_click():
	selected_piece = PieceType.ROOK
	clear_highlights()
	update_occupied_cells()

	var directions = [
		Vector2i(1, 0),  # right
		Vector2i(-1, 0), # left
		Vector2i(0, 1),  # up
		Vector2i(0, -1)  # down
	]

	for dir in directions:
		var current_cell = rook_cell
		while true:
			current_cell += dir
			if not is_cell_in_bounds(current_cell):
				break
			if is_cell_occupied(current_cell):
				break 
			add_highlight(current_cell)


# posible way mark
func add_highlight(cell: Vector2i):
	var highlight = highlight_scene.instantiate()
	highlight.cell = cell
	highlight.tile_clicked.connect(on_tile_clicked)
	set_piece_to_cell(highlight, cell)
	add_child(highlight)
	highlights.append(highlight)


# clear marks
func clear_highlights():
	for node in highlights:
		if node:
			node.queue_free()
	highlights.clear()


# board limit
func is_cell_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < 8 and cell.y >= 0 and cell.y < 8

func is_cell_occupied(cell: Vector2i) -> bool:
	return cell in occupied_cells


func bot_move():
	if bot == null:
		print("Бот не инициализирован!")
		return
		
	bot.pawn_cell = black_pawn_cell
	bot.occupied_cells = occupied_cells.duplicate()

	var move = bot.get_next_move()
	if move != black_pawn_cell:
		black_pawn_cell = move
		set_piece_to_cell($Black_Pawn, black_pawn_cell)
