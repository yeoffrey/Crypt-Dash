extends TileMap

var seen : Array
var view : Array
const TILE_ATLAS_WIDTH : int = 2

func _ready():
	for i in MazeManager.width:
		var newarray = Array()
		seen.append(newarray)
		for j in MazeManager.height:
			seen[i].append(MazeManager.get_value(i,j))

# Updates all the tiles in tile map to display proper tile
func _process(delta):
	var player_pos = get_player_pos()
	if MazeManager.get_value(player_pos.x,player_pos.y) != Enums.TILE_TYPE.FLOOR:
		MazeManager.set_value(player_pos.x,player_pos.y, Enums.TILE_TYPE.FLOOR)
	
	view = update_seen(player_pos, 5)
	
	for i in MazeManager.width:
		for j in MazeManager.height: 
			var tile_atlas_position : Vector2
			var is_seen = false
			for k in view.size():
				if view[k] == Vector2(i,j):
					is_seen = true

			if is_seen:
				if MazeManager.get_value(i,j) == Enums.TILE_TYPE.WALL:
					tile_atlas_position = Vector2(0,0)
				elif MazeManager.get_value(i,j) == Enums.TILE_TYPE.FAKE_WALL:
					tile_atlas_position = Vector2(1,0)
				else:
					tile_atlas_position = Vector2(2,0)
				set_cell(0,Vector2(i,j),0,tile_atlas_position,0)
			else:
				if seen[i][j] == Enums.TILE_TYPE.WALL:
					tile_atlas_position = Vector2(0,1)
				elif seen[i][j] == Enums.TILE_TYPE.FAKE_WALL:
					tile_atlas_position = Vector2(1,1)
				else:
					tile_atlas_position = Vector2(2,1)
				set_cell(0,Vector2(i,j),0,tile_atlas_position,0)
	set_cell(0,MazeManager.end_cell,0,Vector2(3,1),0)
	for k in view.size():
				if view[k] == MazeManager.end_cell:
					set_cell(0,MazeManager.end_cell,0,Vector2(3,0),0)

func update_seen(cell:Vector2, depth:int):
	if depth == 0:
		var new_array = Array()
		return new_array
	seen[cell.x][cell.y] = MazeManager.get_value(cell.x,cell.y)
	var ret : Array
	ret.append(cell)
	for i in 4:
		var neighbor = MazeManager.get_neighbor(cell, i, 1)
		if neighbor != Vector2(-1,-1):
			ret.append_array(update_seen((neighbor),depth-1))
	return ret


func get_player_pos():
	return Vector2(local_to_map(to_local(get_parent().runner.position)))
