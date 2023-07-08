extends Node2D

@onready var maze_map : TileMap = $MazeMap

@export var runner : PackedScene


func _ready():
	var player = runner.instantiate()
	add_child(player)
	player.position = maze_map.to_global(maze_map.map_to_local(MazeManager.start_cell))

