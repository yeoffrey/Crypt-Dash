extends TileMap

var mouse_pos : Vector2 = get_global_mouse_position()
var cell : Vector2 = local_to_map(to_local(mouse_pos))
var runner : Runner

@export var tile_atlas_width : int = 4

func _process(delta):
	for i in MazeManager.width:
		for j in MazeManager.height:
			set_cell(0,Vector2(i,j),0,Vector2(MazeManager.get_value(i,j)%tile_atlas_width,MazeManager.get_value(i,j)/tile_atlas_width), 0)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			var mouse_pos : Vector2 = get_global_mouse_position()
			var cell : Vector2 = local_to_map(to_local(mouse_pos))
			if cell == Vector2(local_to_map(to_local(runner.position))):
				return
			if MazeManager.get_value(cell.x,cell.y) == 1:
				MazeManager.set_value(cell.x,cell.y,3)
			else:
				MazeManager.set_value(cell.x,cell.y,1)
