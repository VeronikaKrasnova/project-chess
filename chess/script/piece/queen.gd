extends "res://script/Piece.gd"

func get_possible_moves(occupied_cells: Array[Vector2i]) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0),                  Vector2i(1, 0),
		Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1)
	]
	for dir in directions:
		var target_cell = cell
		while true:
			target_cell += dir
			if not is_in_bounds(target_cell):
				break
			if target_cell in occupied_cells:
				break
			moves.append(target_cell)
	return moves
