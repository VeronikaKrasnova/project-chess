extends "res://script/Piece.gd"

func get_possible_moves(occupied_cells: Array[Vector2i], enemies: Array[Vector2i]) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var direction = is_white and 1 or -1
	var forward = cell + Vector2i(0, direction)

	# Простой ход вперед
	if is_in_bounds(forward) and not forward in occupied_cells or forward in enemies:
		moves.append(forward)
	
	var double_forward = cell + Vector2i(0, direction) * 2
	if not forward in occupied_cells or forward in enemies:
		if cell.y == 1:
			moves.append(double_forward)

	# Взятие по диагонали
	for dx in [-1, 1]:
		var diag = cell + Vector2i(dx, direction)
		if diag in enemies:
			moves.append(diag)

	return moves
