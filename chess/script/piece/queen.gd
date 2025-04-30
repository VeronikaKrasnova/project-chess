extends "res://script/Piece.gd"

func get_possible_moves(occupied_cells: Array[Vector2i], enemies: Array[Vector2i]) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0),                  Vector2i(1, 0),
		Vector2i(-1, 1),  Vector2i(0, 1),  Vector2i(1, 1)
	]
	for dir in directions:
		var current = cell + dir
		while is_in_bounds(current):
			if current in occupied_cells:
				if current in enemies:
					moves.append(current) # можно съесть врага
				break # путь заблокирован
			moves.append(current)
			current += dir
	return moves
