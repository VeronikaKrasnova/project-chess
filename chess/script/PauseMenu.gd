extends Node

func _ready():
	$Window.visible = false

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	$Window.visible = false


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	$Window.visible = true
