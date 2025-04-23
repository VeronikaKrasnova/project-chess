extends Node2D

var tile_size := 70
var board_origin := Vector2( 0, 0) # left top angle of board position 
var board_size := Vector2(8, 8)  # board size (8x8 tiles)
var pawn_cell := Vector2i(2, 1) # pawn start position

var highlight_scene := preload("res://HighlightTile.tscn")
var highlights := []


# placing objects
func _ready():
	board_origin = $Board.position + Vector2(20, 20)  # got board position in px
	$CanvasLayer/PausePanel.hide() # hide pause menu
	
	set_piece_to_cell($Pawn, pawn_cell)
	$Pawn.left_click.connect(on_pawn_left_click) # got signal



# coordinate marking on the board
func set_piece_to_cell(piece: Node2D, cell: Vector2i):
	var corrected_y = 7 - cell.y
	var cell_position = board_origin + Vector2(cell.x, corrected_y) * tile_size
	@warning_ignore("integer_division")
	piece.position = cell_position + Vector2(tile_size / 2, tile_size / 2)


# move pawn to chosen tile
func on_tile_clicked(target_cell: Vector2i):
	pawn_cell = target_cell
	set_piece_to_cell($Pawn, pawn_cell)
	clear_highlights()


# show posible pawn ways
func on_pawn_left_click():
	clear_highlights()
	
	var forward_cell_1 := pawn_cell + Vector2i(0, 1)
	add_highlight(forward_cell_1)
	
	# if pawn in start position (y == 1)
	if pawn_cell.y == 1:
		var forward_cell_2 := pawn_cell + Vector2i(0, 2)
		add_highlight(forward_cell_2)


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


# pause button
func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	$CanvasLayer/PausePanel.visible = true


# pause menu buttons
func _on_continue_pressed() -> void: # continue button
	get_tree().paused = false
	$CanvasLayer/PausePanel.hide()


func _on_restart_pressed() -> void: # restart button
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void: # quit button
	get_tree().quit()
