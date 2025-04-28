extends Node2D

var tile_size := 100
var board_origin := Vector2( 0, 0) # left top angle of board position 

var knight_scene = preload("res://scenes/Knight.tscn")
var bishop_scene = preload("res://scenes/Bishop.tscn")
var king_scene = preload("res://scenes/King.tscn")
var queen_scene = preload("res://scenes/Queen.tscn")
var rook_scene = preload("res://scenes/Rook.tscn")
var white_pawn_scene := preload("res://scenes/whitePawn.tscn")
var white_pawn_cells: Array[Vector2i] = []

var black_pawn_cell := Vector2i(4, 6)


var selected_node: Node2D = null
var pieces = []

var highlight_scene := preload("res://scenes/HighlightTile.tscn")
var highlights := []

var occupied_cells: Array[Vector2i] = []

var bot : Bot = preload("res://script/bot.gd").new()



# placing objects
func _ready():
	board_origin = $Board.position + Vector2(30, 30)  # got board position in px
	
	spawn_piece(rook_scene, Vector2i(0, 0), "pieces")
	spawn_piece(rook_scene, Vector2i(7, 0), "pieces")
	spawn_piece(king_scene, Vector2i(4, 0), "pieces")
	spawn_piece(bishop_scene, Vector2i(2, 0), "pieces")
	spawn_piece(bishop_scene, Vector2i(5, 0), "pieces")
	spawn_piece(knight_scene, Vector2i(1, 0), "pieces")
	spawn_piece(knight_scene, Vector2i(6, 0), "pieces")
	spawn_piece(queen_scene, Vector2i(3, 0), "pieces")
	
	for x in range(8):
		var cell = Vector2i(x, 1)
		spawn_piece(white_pawn_scene, cell, "pieces")



func spawn_piece(scene: PackedScene, cell: Vector2i, group_name: String = "") -> Node2D:
	var piece = scene.instantiate()
	add_child(piece)
	
	piece.cell = cell
	piece.update_position()
	piece.board_origin = board_origin
	
	piece.left_click.connect(on_piece_clicked.bind(piece))
	
	if group_name != "":
		piece.add_to_group(group_name)
	
	return piece

func on_piece_clicked(piece):
	selected_node = piece
	clear_highlights()
	update_occupied_cells()
	
	var possible_moves = piece.get_possible_moves(occupied_cells)
	for move in possible_moves:
		add_highlight(move)



# coordinate marking on the board
func set_piece_to_cell(piece: Node2D, cell: Vector2i):
	var corrected_y = 7 - cell.y
	var cell_position = board_origin + Vector2(cell.x, corrected_y) * tile_size
	@warning_ignore("integer_division")
	piece.position = cell_position + Vector2(tile_size / 2, tile_size / 2)



#check empty cells
func update_occupied_cells():
	occupied_cells.clear()
	for piece in get_tree().get_nodes_in_group("pieces"):
		occupied_cells.append(piece.cell)


# move chosen piece to chosen cell
func on_tile_clicked(target_cell: Vector2i):
	if selected_node:
		selected_node.set_cell(target_cell)
		selected_node = null
	clear_highlights()
	update_occupied_cells()
	bot_move()



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
