extends Node2D

class_name Maker

var maze_position : Vector2
var maze : TileMap
var inventory : Inventory
var manager : GameManager
var rng = RandomNumberGenerator.new()

var inputs = ["p2_up", "p2_right", "p2_down", "p2_left", "p2_1", "p2_2", "p2_3", "p2_4", "p2_5", "p2_interact", "p2_cancel", "p2_switch"]

@export var oil : PackedScene
@export var bomb : PackedScene
@export var boulder : PackedScene

func _ready():
	maze_position = MazeManager.start_cell

func _process(delta):
	position = Vector2(maze_position.x * 16 + 8, maze_position.y * 16 + 8)

func spawn_trap(val:int):
	var trap_instance 
	if val == 0:
		trap_instance = oil.instantiate()
	elif val == 1:
		trap_instance = bomb.instantiate()
	else:
		trap_instance = boulder.instantiate()
	get_parent().add_child(trap_instance)
	trap_instance.position = position
	trap_instance.manager = manager

func _input(event):
	if event.is_action_pressed(inputs[0]) && MazeManager.get_neighbor(maze_position,0) != Vector2(-1,-1):
		maze_position = MazeManager.get_neighbor(maze_position,0,1)
	if event.is_action_pressed(inputs[1]) && MazeManager.get_neighbor(maze_position,1) != Vector2(-1,-1):
		maze_position = MazeManager.get_neighbor(maze_position,1,1)
	if event.is_action_pressed(inputs[2]) && MazeManager.get_neighbor(maze_position,2) != Vector2(-1,-1):
		maze_position = MazeManager.get_neighbor(maze_position,2,1)
	if event.is_action_pressed(inputs[3]) && MazeManager.get_neighbor(maze_position,3) != Vector2(-1,-1):
		maze_position = MazeManager.get_neighbor(maze_position,3,1)
	
	if event.is_action_pressed(inputs[4]) || event.is_action_pressed(inputs[5]) || event.is_action_pressed(inputs[6]) || event.is_action_pressed(inputs[7]) || event.is_action_pressed(inputs[8]) || event.is_action_pressed(inputs[10]) || event.is_action_pressed(inputs[11]):
		var val = MazeManager.get_value(maze_position.x, maze_position.y)
		if not_trap(val) && maze_position != maze.get_player_pos():
			if event.is_action_pressed(inputs[4]) && manager.walls > 0 && val != Enums.TILE_TYPE.WALL:
				manager.walls -= 1
				MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.WALL)
				
				var solvable : bool
				solvable = MazeManager.is_solvable(maze.get_player_pos())
				if solvable:
					SoundManager.play("place")
					return
				
				var walls : Array
				for i in MazeManager.width:
					for j in MazeManager.height:
						if (MazeManager.get_value(i,j) == Enums.TILE_TYPE.WALL && Vector2(i,j) != maze_position && i != 0 && i != MazeManager.width-1 && j != 0 && j != MazeManager.height-1):
							walls.append(Vector2(i,j))

				while !(solvable):
					if walls.size() == 0:
						MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.FLOOR)
						manager.walls += 1
						SoundManager.play("buzzer")
						break
					var index = 0
					MazeManager.set_value(walls[index].x, walls[index].y, Enums.TILE_TYPE.FLOOR)
					manager.walls += 1
					solvable = MazeManager.is_solvable(maze.get_player_pos())
					if !solvable:
						MazeManager.set_value(walls[index].x, walls[index].y, Enums.TILE_TYPE.WALL)
						manager.walls -= 1
					else:
						SoundManager.play("place")
					walls.remove_at(index)
				

			if event.is_action_pressed(inputs[5]) && inventory.fake_wall > 0:
				if val == Enums.TILE_TYPE.WALL:
					manager.walls += 1
				MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.FAKE_WALL)
				inventory.place_fake_wall()
				SoundManager.play("place")
			if event.is_action_pressed(inputs[6]) && inventory.oil:
				if val == Enums.TILE_TYPE.WALL:
					manager.walls += 1
				MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.OIL)
				spawn_trap(0)
				inventory.place_oil()
				SoundManager.play("place")
			if event.is_action_pressed(inputs[7]) && inventory.bomb:
				if val == Enums.TILE_TYPE.WALL:
					manager.walls += 1
				MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.BOMB)
				spawn_trap(1)
				inventory.place_bomb()
				SoundManager.play("place")
			if event.is_action_pressed(inputs[8]) && inventory.boulder:
				if val == Enums.TILE_TYPE.WALL:
					manager.walls += 1
				MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.BOULDER)
				spawn_trap(2)
				inventory.place_boulder()
				SoundManager.play("place")
			if event.is_action_pressed(inputs[10]) && MazeManager.get_value(maze_position.x, maze_position.y) != Enums.TILE_TYPE.FLOOR:
				if MazeManager.get_value(maze_position.x, maze_position.y) == Enums.TILE_TYPE.WALL:
					manager.walls += 1
				MazeManager.set_value(maze_position.x, maze_position.y, Enums.TILE_TYPE.FLOOR)
				SoundManager.play("place")
		else:
			SoundManager.play("buzzer")
		if event.is_action_pressed(inputs[11]) && manager.can_maker_switch():
			manager.switch_state()




func not_trap(val:int):
	return val != Enums.TILE_TYPE.OIL && val != Enums.TILE_TYPE.BOULDER && val != Enums.TILE_TYPE.BOMB && val != Enums.TILE_TYPE.PICKUP
