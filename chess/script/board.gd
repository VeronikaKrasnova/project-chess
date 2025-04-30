extends Node2D

var tile_size := 100
var board_origin := Vector2( 0, 0) # left top angle of board position 

var knight_scene = preload("res://scenes/piece/white/Knight.tscn")
var bishop_scene = preload("res://scenes/piece/white/Bishop.tscn")
var king_scene = preload("res://scenes/piece/white/King.tscn")
var queen_scene = preload("res://scenes/piece/white/Queen.tscn")
var rook_scene = preload("res://scenes/piece/white/Rook.tscn")
var white_pawn_scene := preload("res://scenes/piece/white/whitePawn.tscn")

var black_knight_scene  = preload("res://scenes/piece/Black/Black_Knight.tscn")
var black_bishop_scene  = preload("res://scenes/piece/Black/Black_Bishop.tscn")
var black_king_scene = preload("res://scenes/piece/Black/Black_King.tscn")
var black_queen_scene  = preload("res://scenes/piece/Black/Black_Queen.tscn")
var black_rook_scene  = preload("res://scenes/piece/Black/Black_Rook.tscn")
var black_pawn_scene  = preload("res://scenes/piece/Black/Black_pawn.tscn")


var white_pawn_cells: Array[Vector2i] = []

var black_pieces: Array[Node2D] = []


var selected_node: Node2D = null
var pieces = []

var highlight_scene := preload("res://scenes/HighlightTile.tscn")
var highlights := []

var occupied_cells: Array[Vector2i] = []
var enemies: Array[Vector2i] = []

var bot : = preload("res://script/bot.gd").new()



# placing objects
func _ready():
	board_origin = $Board.position + Vector2(30, 30)  # got board position in px
	
	spawn_piece(rook_scene, Vector2i(0, 0), "pieces")
	spawn_piece(knight_scene, Vector2i(1, 0), "pieces")
	spawn_piece(bishop_scene, Vector2i(2, 0), "pieces")
	spawn_piece(queen_scene, Vector2i(3, 0), "pieces")
	spawn_piece(king_scene, Vector2i(4, 0), "pieces")
	spawn_piece(bishop_scene, Vector2i(5, 0), "pieces")
	spawn_piece(knight_scene, Vector2i(6, 0), "pieces")
	spawn_piece(rook_scene, Vector2i(7, 0), "pieces")
	
	spawn_black_piece(black_rook_scene, Vector2i(0, 7), "pieces")
	spawn_black_piece(black_knight_scene, Vector2i(1, 7), "pieces")
	spawn_black_piece(black_bishop_scene, Vector2i(2, 7), "pieces")
	spawn_black_piece(black_queen_scene, Vector2i(3, 7), "pieces")
	spawn_black_piece(black_king_scene, Vector2i(4, 7), "pieces")
	spawn_black_piece(black_bishop_scene, Vector2i(5, 7), "pieces")
	spawn_black_piece(black_knight_scene, Vector2i(6, 7), "pieces")
	spawn_black_piece(black_rook_scene, Vector2i(7, 7), "pieces")
	
	for x in range(8):
		var cell = Vector2i(x, 1)
		spawn_piece(white_pawn_scene, cell, "pieces")
		
	for x in range(8):
		var cell = Vector2i(x, 6)
		spawn_black_piece(black_pawn_scene, cell, "pieces")


func get_black_pieces():
	black_pieces.clear()
	for piece in get_tree().get_nodes_in_group("pieces"):
		if not piece.is_white:
			black_pieces.append(piece)



func spawn_piece(scene: PackedScene, cell: Vector2i, group_name: String = "") -> Node2D:
	var piece = scene.instantiate()
	add_child(piece)
	
	piece.cell = cell
	piece.update_position()
	piece.board_origin = board_origin
	piece.is_white = true
	piece.left_click.connect(on_piece_clicked.bind(piece))
	if group_name != "":
		piece.add_to_group(group_name)
	
	return piece

func spawn_black_piece(scene: PackedScene, cell: Vector2i, group_name: String = "") -> Node2D:
	var piece = scene.instantiate()
	piece.is_white = false
	add_child(piece)
	piece.cell = cell
	piece.update_position()
	piece.board_origin = board_origin
	if group_name != "":
		piece.add_to_group(group_name)
	return piece



func on_piece_clicked(piece):
	selected_node = piece
	clear_highlights()

	var all_pieces = get_tree().get_nodes_in_group("pieces")
	@warning_ignore("shadowed_variable")

	for other_piece in all_pieces:
		occupied_cells.append(other_piece.cell)
		if other_piece.is_white != piece.is_white:
			enemies.append(other_piece.cell)

	var possible_moves = piece.get_possible_moves(occupied_cells, enemies)

	for move in possible_moves:
		add_highlight(move)



# coordinate marking on the board
func set_piece_to_cell(piece: Node2D, cell: Vector2i):
	var corrected_y = 7 - cell.y
	var cell_position = board_origin + Vector2(cell.x, corrected_y) * tile_size
	@warning_ignore("integer_division")
	piece.position = cell_position + Vector2(tile_size / 2, tile_size / 2)


func get_piece_at_cell(cell: Vector2i) -> Node2D:
	for piece in get_tree().get_nodes_in_group("pieces"):
		if piece.cell == cell:
			return piece
	return null


func capture_piece(piece: Node2D):
	piece.queue_free()

#check empty cells
func update_occupied_cells():
	occupied_cells.clear()
	for piece in get_tree().get_nodes_in_group("pieces"):
		occupied_cells.append(piece.cell)


# move chosen piece to chosen cell
func on_tile_clicked(target_cell: Vector2i):
	if selected_node:
		# Удалить врага, если он на целевой клетке
		for piece in get_tree().get_nodes_in_group("pieces"):
			if piece.cell == target_cell and piece.is_white != selected_node.is_white:
				piece.queue_free()
				break

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

	get_black_pieces()
	update_occupied_cells()

	for piece in black_pieces:
		var moves = piece.get_possible_moves(occupied_cells, enemies)
		if moves.size() > 0:
			var move = moves.pick_random()
			var target = get_piece_at_cell(move)
			if target and target.is_white:
				target.queue_free()
				occupied_cells.erase(target.cell)

			piece.set_cell(move)
			update_occupied_cells()
			break 
