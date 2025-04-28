extends "res://script/Piece.gd"

func get_possible_moves(occupied_cells: Array[Vector2i]) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var directions = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]
	for dir in directions:
		var current = cell
		while true:
			current += dir
			if not is_in_bounds(current) or current in occupied_cells:
				break
			moves.append(current)
	return moves
