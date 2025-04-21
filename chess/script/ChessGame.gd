extends Node2D

var tile_size := 70
var board_origin := Vector2( 0, 0) # положение левого верхнего угла доски
var board_size := Vector2(8, 8)  # Размер доски (8x8 клеток)
var pawn_cell := Vector2i(2, 2) # Пешка


# Растановка фигур
func _ready():
	board_origin = $Board.position + Vector2(20, 20)  # Получаем позицию доски в пикселях
	
	set_piece_to_cell($Pawn, pawn_cell)
	$Pawn.left_click.connect(on_pawn_left_click)


func on_pawn_left_click():
	move_pawn_forward()


# Обозначение координат на поле
func screen_to_cell(pos: Vector2) -> Vector2i:
	var local_pos = pos - board_origin
	var x = floor(local_pos.x / tile_size)
	var y = floor(local_pos.y / tile_size) # переворачиваем обратно
	return Vector2i(x, 7 - y)


# Размещение фигурки
func set_piece_to_cell(piece: Node2D, cell: Vector2i):
	var corrected_y = 7 - cell.y
	var cell_position = board_origin + Vector2(cell.x, corrected_y) * tile_size
	piece.position = cell_position + Vector2(tile_size / 2, tile_size / 2)


# Движение пешки на 1 клетку вперёд
func move_pawn_forward():
	if pawn_cell.y < 7:
		pawn_cell.y += 1
		set_piece_to_cell($Pawn, pawn_cell)
