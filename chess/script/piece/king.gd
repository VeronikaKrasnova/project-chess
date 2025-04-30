extends "res://script/Piece.gd"

func get_possible_moves(occupied_cells: Array[Vector2i], enemies: Array[Vector2i]) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0),                  Vector2i(1, 0),
		Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1)
	]
	for dir in directions:
		var target_cell = cell + dir
		if is_in_bounds(target_cell) and (not target_cell in occupied_cells or target_cell in enemies):
			moves.append(target_cell)
	return moves
