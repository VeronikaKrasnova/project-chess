extends Sprite2D

func _ready():
	texture = load("res://assets/TestUnit.jpg")

signal left_click  # create signal

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(event.position)):
			emit_signal("left_click")  # sand signal
