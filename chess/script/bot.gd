extends Resource
class_name Bot

# Позиция пешки
var pawn_cell: Vector2i
# Все занятые клетки на доске (включая короля и т.п.)
var occupied_cells: Array[Vector2i] = []

# Возвращает следующую клетку для хода
func get_next_move() -> Vector2i:
	var forward := pawn_cell + Vector2i(0, -1)
	if forward not in occupied_cells and is_cell_in_bounds(forward):
		return forward
	return pawn_cell  # если не может сходить
	

func is_cell_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < 8 and cell.y >= 0 and cell.y < 8
