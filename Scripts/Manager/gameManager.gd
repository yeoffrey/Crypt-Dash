extends Node2D

class_name GameManager

@onready var maze_map : TileMap = $MazeMap

@onready var ui = $GameUserInterface

@onready var p1timer : Timer = ui.p1.timer
@onready var p2timer : Timer = ui.p1.timer
var p1clock : float = 60.0
var p2clock : float = 60.0

var p1_inputs = ["p1_up", "p1_right", "p1_down", "p1_left", "p1_1", "p1_2", "p1_3", "p1_4", "p1_5", "p1_interact", "p1_cancel", "p1_switch"]
var p2_inputs = ["p2_up", "p2_right", "p2_down", "p2_left", "p2_1", "p2_2", "p2_3", "p2_4", "p2_5", "p2_interact", "p2_cancel", "p2_switch"]



@onready var p1_inventory = Inventory.new(ui.p1.oil_cooldown,ui.p1.bomb_cooldown)
@onready var p2_inventory = Inventory.new(ui.p2.oil_cooldown,ui.p2.bomb_cooldown)

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
	
	if last_player_pos != maze_map.get_player_pos():
		last_player_pos = maze_map.get_player_pos()
		give_points_runner(1)
	
	if (switches % 2 == 1):
		if (maze_map.get_player_pos() == MazeManager.end_cell):
			end_game(1)
		p1clock = p1timer.time_left
	else:
		if (maze_map.get_player_pos() == MazeManager.end_cell):
			end_game(2)
		p2clock = p2timer.time_left
	
	ui.p1.timer_label.text = str(p1clock).pad_decimals(0)
	ui.p1.wall_label.text = str(walls)
	ui.p1.fake_wall_label.text = str(p1_inventory.fake_wall)
	ui.p1.boulder_label.text = str(p1_inventory.boulder)
	
	
	ui.p2.timer_label.text = str(p2clock).pad_decimals(0)
	ui.p2.wall_label.text = str(walls)
	ui.p2.fake_wall_label.text = str(p2_inventory.fake_wall)
	ui.p2.boulder_label.text = str(p2_inventory.boulder)
	



func switch_state():
	switches += 1
	if (switches != 1):
		SoundManager.play("switch")
	ui.p1.switch_bar.value = 0
	ui.p2.switch_bar.value = 0
	if (switches % 2 == 1):
		runner.inputs = p1_inputs
		maker.inputs = p2_inputs
		p1timer.start(p1clock)
		p2timer.stop()
		p1_inventory = maker.inventory
		maker.inventory = p2_inventory
		ui.p1.color_bar.color = floor_color
		ui.p2.color_bar.color = wall_color
	else:
		runner.inputs = p2_inputs
		maker.inputs = p1_inputs
		p1timer.stop()
		p2timer.start(p2clock)
		p2_inventory = maker.inventory
		maker.inventory = p1_inventory
		ui.p2.color_bar.color = floor_color
		ui.p1.color_bar.color = wall_color

func end_game(winner:int):
	Globaldata.winner = winner
	GameSceneManager.switch("win")

func _on_p_1_timer_timeout():
	end_game(2)

func _on_p_2_timer_timeout():
	end_game(1)

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
		if ui.p1.switch_bar.value < 5:
			ui.p1.switch_bar.value = min(5, ui.p1.switch_bar.value + points)
	else:
		if ui.p2.switch_bar.value < 5:
			ui.p2.switch_bar.value = min(5, ui.p2.switch_bar.value + points)

func give_points_runner(points:int):
	if (switches % 2 == 1):
		if ui.p1.switch_bar.value < 5:
			ui.p1.switch_bar.value = min(5, ui.p1.switch_bar.value + points)
	else:
		if ui.p2.switch_bar.value < 5:
			ui.p2.switch_bar.value = min(5, ui.p2.switch_bar.value + points)

func can_maker_switch():
	if (switches % 2 == 0):
		return ui.p1.switch_bar.value == 5
	else:
		return ui.p2.switch_bar.value == 5

func can_runner_switch():
	if (switches % 2 == 1):
		return ui.p1.switch_bar.value == 5
	else:
		return ui.p1.switch_bar.value == 5

func give_pickup(type:int):
	SoundManager.play("pickup",true)
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
	MazeManager.set_value(floors[index].x, floors[index].y, Enums.TILE_TYPE.PICKUP)
	pickup_instance.set_type(rng.randi_range(0,1))
	pickup_instance.manager = self
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

