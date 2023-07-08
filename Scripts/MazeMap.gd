extends TileMap

var mouse_pos : Vector2 = get_global_mouse_position()
var cell : Vector2 = local_to_map(to_local(mouse_pos))
var runner : Runner

const TILE_ATLAS_WIDTH : int = 2

# Updates all the tiles in tile map to display proper tile
func _process(delta):
	for i in MazeManager.width:
		for j in MazeManager.height:
			set_cell(0,Vector2(i,j),0,Vector2(MazeManager.get_value(i,j)%TILE_ATLAS_WIDTH,MazeManager.get_value(i,j)/TILE_ATLAS_WIDTH), 0)

# This will all be changed in future
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			var mouse_pos : Vector2 = get_global_mouse_position()
			var cell : Vector2 = local_to_map(to_local(mouse_pos))
			if cell == Vector2(local_to_map(to_local(runner.position))):
				return
			if MazeManager.get_value(cell.x,cell.y) == Enums.TILE_TYPE.FLOOR:
				MazeManager.set_value(cell.x,cell.y,Enums.TILE_TYPE.WALL)
			else:
				MazeManager.set_value(cell.x,cell.y,Enums.TILE_TYPE.FLOOR)
