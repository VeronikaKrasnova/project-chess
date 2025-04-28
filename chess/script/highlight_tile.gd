extends Area2D

signal tile_clicked(cell: Vector2i)
var cell: Vector2i

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tile_clicked.emit(cell)
