extends Node

var board = null

func get_next_move() -> void:
	var black_pieces = get_tree().get_nodes_in_group("pieces").filter(func(p): return not p.is_white)
	var white_pieces = get_tree().get_nodes_in_group("pieces").filter(func(p): return p.is_white)

	var occupied_cells: Array[Vector2i] = []
	var enemy_cells: Array[Vector2i] = []
	var friendly_cells: Array[Vector2i] = []

	for piece in black_pieces + white_pieces:
		occupied_cells.append(piece.cell)
		if piece.is_white:
			enemy_cells.append(piece.cell)
		else:
			friendly_cells.append(piece.cell)

	for piece in black_pieces:
		var moves = piece.get_possible_moves(occupied_cells, enemy_cells)
		# Фильтруем ходы, чтобы не вставать на союзников
		moves = moves.filter(func(cell): return not cell in friendly_cells)

		if moves.size() > 0:
			var chosen_move = moves.pick_random()
			var target = board.get_piece_at_cell(chosen_move)
			if target and target.is_white:
				if is_instance_valid(target):
					target.queue_free()
			piece.set_cell(chosen_move)
			break
