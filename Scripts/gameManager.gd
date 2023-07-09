extends Node2D

class_name GameManager

@onready var maze_map : TileMap = $MazeMap
@onready var p1timer : Timer = $P1Timer
@onready var p2timer : Timer = $P2Timer


@onready var p1_timer_label : Label = $P1UI/TimerLabel
@onready var p1_wall_label : Label = $P1UI/Wall/WallLabel
@onready var p1_fake_wall_label : Label = $P1UI/FakeWall/FakeWallLabel
@onready var p1_boulder_label : Label = $P1UI/Boulder/BoulderLabel
@onready var p1_oil_cooldown : Cooldown = $P1UI/OilCooldown
@onready var p1_bomb_cooldown : Cooldown = $P1UI/BombCooldown
@onready var p1_switch_bar = $P1UI/TextureProgressBar
@onready var p1_color_bar = $P1UI/Background

@onready var p2_timer_label : Label = $P2UI/TimerLabel
@onready var p2_wall_label : Label = $P2UI/Wall/WallLabel
@onready var p2_fake_wall_label : Label = $P2UI/FakeWall/FakeWallLabel
@onready var p2_boulder_label : Label = $P2UI/Boulder/BoulderLabel
@onready var p2_oil_cooldown : Cooldown = $P2UI/OilCooldown
@onready var p2_bomb_cooldown : Cooldown = $P2UI/BombCooldown
@onready var p2_switch_bar = $P2UI/TextureProgressBar
@onready var p2_color_bar = $P2UI/Background

var p1clock : float = 60.0
var p2clock : float = 60.0

var p1_inputs = ["p1_up", "p1_right", "p1_down", "p1_left", "p1_1", "p1_2", "p1_3", "p1_4", "p1_5", "p1_interact", "p1_cancel", "p1_switch"]
var p2_inputs = ["p2_up", "p2_right", "p2_down", "p2_left", "p2_1", "p2_2", "p2_3", "p2_4", "p2_5", "p2_interact", "p2_cancel", "p2_switch"]

@onready var p1_inventory = Inventory.new(p1_oil_cooldown,p1_bomb_cooldown)

@onready var p2_inventory = Inventory.new(p2_oil_cooldown,p2_bomb_cooldown)

var walls : int

var switches : int = 0
var runner : Runner
var maker : Maker
var last_player_pos = MazeManager.start_cell

var floor_color : Color = Color(0.75686275959015, 0.69803923368454, 0.58039218187332)
var wall_color : Color = Color(0.3137255012989, 0.19215686619282, 0.13725490868092)

@export var runner_scence : PackedScene
@export var maker_scene : PackedScene
@export var pickup_scene : PackedScene

var rng = RandomNumberGenerator.new()

func _init():
	MazeManager.randomize_maze()

func _ready():
	var runner_instance = runner_scence.instantiate()
	var maker_instance = maker_scene.instantiate()
	maker_instance.maze = maze_map
	runner_instance.manager = self
	maker_instance.manager = self
	maker_instance.inventory = p1_inventory
	runner = runner_instance
	maker = maker_instance
	add_child(runner_instance)
	add_child(maker_instance)
	runner_instance.position = maze_map.to_global(maze_map.map_to_local(MazeManager.start_cell))
	maker_instance.position = maze_map.to_global(maze_map.map_to_local(MazeManager.start_cell))
	switch_state()

func _process(delta):
	if (maze_map.get_player_pos() == MazeManager.end_cell):
		end_game()
	
	if last_player_pos != maze_map.get_player_pos():
		last_player_pos = maze_map.get_player_pos()
		give_points_runner(1)
	
	if (switches % 2 == 1):
		p2clock = p2timer.time_left
	else:
		p1clock = p1timer.time_left
	
	p1_timer_label.text = str(p1clock).pad_decimals(0)
	p1_wall_label.text = str(walls)
	p1_fake_wall_label.text = str(p1_inventory.fake_wall)
	p1_boulder_label.text = str(p1_inventory.boulder)
	
	
	p2_timer_label.text = str(p2clock).pad_decimals(0)
	p2_wall_label.text = str(walls)
	p2_fake_wall_label.text = str(p2_inventory.fake_wall)
	p2_boulder_label.text = str(p2_inventory.boulder)
	



func switch_state():
	switches += 1
	p1_switch_bar.value = 0
	p2_switch_bar.value = 0
	if (switches % 2 == 1):
		runner.inputs = p1_inputs
		maker.inputs = p2_inputs
		p2timer.start(p2clock)
		p1timer.stop()
		p1_inventory = maker.inventory
		maker.inventory = p2_inventory
		p1_color_bar.color = floor_color
		p2_color_bar.color = wall_color
	else:
		runner.inputs = p2_inputs
		maker.inputs = p1_inputs
		p2timer.stop()
		p1timer.start(p1clock)
		p2_inventory = maker.inventory
		maker.inventory = p1_inventory
		p2_color_bar.color = floor_color
		p1_color_bar.color = wall_color

func end_game():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_p_1_timer_timeout():
	end_game()

func _on_p_2_timer_timeout():
	end_game()

func _on_p1_oil_timer_timeout():
	p1_inventory.oil = true

func _on_p1_bomb_timer_timeout():
	p1_inventory.bomb = true

func _on_p2_oil_timer_timeout():
	p2_inventory.oil = true

func _on_p2_bomb_timer_timeout():
	p2_inventory.bomb = true

func give_points_maker(points:int):
	if (switches % 2 == 0):
		if p1_switch_bar.value < 5:
			p1_switch_bar.value = min(5, p1_switch_bar.value + points)
	else:
		if p2_switch_bar.value < 5:
			p2_switch_bar.value = min(5, p2_switch_bar.value + points)

func give_points_runner(points:int):
	if (switches % 2 == 1):
		if p1_switch_bar.value < 5:
			p1_switch_bar.value = min(5, p1_switch_bar.value + points)
	else:
		if p2_switch_bar.value < 5:
			p2_switch_bar.value = min(5, p2_switch_bar.value + points)

func can_maker_switch():
	if (switches % 2 == 0):
		return p1_switch_bar.value == 5
	else:
		return p2_switch_bar.value == 5

func can_runner_switch():
	if (switches % 2 == 1):
		return p1_switch_bar.value == 5
	else:
		return p2_switch_bar.value == 5

func give_pickup(type:int):
	if type == 0:
		if (switches % 2 == 1):
			p1_inventory.fake_wall += 1
		else:
			p2_inventory.fake_wall += 1
	else:
		if (switches % 2 == 1):
			p1_inventory.boulder += 1
		else:
			p2_inventory.boulder += 1

func spawn_pickup():
	var pickup_instance = pickup_scene.instantiate()
	pickup_instance.hide()
	add_child(pickup_instance)
	
	var floors : Array
	for i in MazeManager.width:
		for j in MazeManager.height:
			if (MazeManager.get_value(i,j) == Enums.TILE_TYPE.FLOOR && Vector2(i,j) != last_player_pos):
				floors.append(Vector2(i,j))
		
	if floors.size() == 0:
		pickup_instance.queue_free()
		return false
	var index = rng.randi_range(0,floors.size()-1)
	pickup_instance.position = Vector2(floors[index].x*16 + 8, floors[index].y*16 + 8)
	pickup_instance.set_type(rng.randi_range(0,1))
	pickup_instance.manager = self
	print("spawned")
	return true



func _on_p1_texture_progress_bar_value_changed(value):
	if value == 5:
		var ran = rng.randi_range(0,3)
		for i in ran:
			spawn_pickup()


func _on_p2_texture_progress_bar_value_changed(value):
	if value == 5:
		var ran = rng.randi_range(0,3)
		for i in ran:
			spawn_pickup()
