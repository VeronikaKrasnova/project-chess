extends Node

var occupied_cells: Array[Vector2i] = []
var board = null

func get_next_move() -> void:
	var black_pieces = get_tree().get_nodes_in_group("pieces").filter(func(p): return not p.is_white)
	var white_pieces = get_tree().get_nodes_in_group("pieces").filter(func(p): return p.is_white)
	
	var enemies = []

	for piece in black_pieces + white_pieces:
		occupied_cells.append(piece.cell)
		if piece.is_white:
			enemies.append(piece.cell)

	for piece in black_pieces:
		var moves = piece.get_possible_moves(occupied_cells, enemies)
		if moves.size() > 0:
			var chosen_move = moves.pick_random()
			piece.set_cell(chosen_move)
			break
