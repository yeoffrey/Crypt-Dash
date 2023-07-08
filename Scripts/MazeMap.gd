extends TileMap

var mouse_pos : Vector2 = get_global_mouse_position()
var cell : Vector2 = local_to_map(to_local(mouse_pos))

func _process(delta):
	for i in MazeManager.width:
		for j in MazeManager.height:
			set_cell(0,Vector2(i,j),0,Vector2(MazeManager.get_value(i,j)%3,MazeManager.get_value(i,j)/3), 0)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			var mouse_pos : Vector2 = get_global_mouse_position()
			var cell : Vector2 = local_to_map(to_local(mouse_pos))
			if MazeManager.get_value(cell.x,cell.y) == 1:
				MazeManager.set_value(cell.x,cell.y,0)
			else:
				MazeManager.set_value(cell.x,cell.y,1)
