extends Node2D
var is_white: bool

signal left_click()

var cell: Vector2i
var board_origin
var tile_size

func _ready():
	update_position()

func set_cell(new_cell: Vector2i):
	print(name, " переместилась с ", cell, " на ", new_cell)
	cell = new_cell
	update_position()

func update_position():
	var board = get_parent()
	if board == null:
		return
	board_origin = board.board_origin
	tile_size = board.tile_size
	var corrected_y = 7 - cell.y
	position = board_origin + Vector2(cell.x, corrected_y) * tile_size + Vector2(tile_size / 2, tile_size / 2)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		left_click.emit()

# --- Абстрактная функция ---
func get_possible_moves(_occupied_cells: Array[Vector2i], _enemies: Array[Vector2i]) -> Array[Vector2i]:
	return []

func is_in_bounds(c: Vector2i) -> bool:
	return c.x >= 0 and c.x < 8 and c.y >= 0 and c.y < 8
