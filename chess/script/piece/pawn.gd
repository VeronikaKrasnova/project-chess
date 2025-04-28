extends "res://script/Piece.gd"

func get_possible_moves(occupied_cells: Array[Vector2i]) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var forward = Vector2i(0, 1)
	var one_ahead = cell + forward
	if not one_ahead in occupied_cells and is_in_bounds(one_ahead):
		moves.append(one_ahead)

	if cell.y == 1:
		var two_ahead = cell + forward * 2
		if not two_ahead in occupied_cells and not one_ahead in occupied_cells and is_in_bounds(two_ahead):
			moves.append(two_ahead)

	return moves
