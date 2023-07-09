extends CharacterBody2D

class_name Runner

@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]
@onready var timer = $Timer
var manager : GameManager


var inputs = ["p1_up", "p1_right", "p1_down", "p1_left", "p1_1", "p1_2", "p1_3", "p1_4", "p1_5", "p1_interact", "p1_cancel", "p1_switch"]
var can_move : bool = true

const SPEED : float = 50.0
var direction_x : int
var direction_y : int

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	if can_move:
		update_velocity()
	move_and_slide()
	if can_move:
		update_animation()

func update_animation():
	if (Input.is_action_pressed(inputs[0]) || Input.is_action_pressed(inputs[3]) || Input.is_action_pressed(inputs[1]) || Input.is_action_pressed(inputs[2])):
		animation_tree.set("parameters/idle/blend_position", Vector2(direction_x, -direction_y))
		animation_tree.set("parameters/running/blend_position", Vector2(direction_x, -direction_y))
	if velocity != Vector2.ZERO:
		manager.sound_manager.play_footsteps()
		playback.travel("running")
	else:
		manager.sound_manager.stop_footsteps()
		playback.travel("idle")

func update_velocity():
	# Get the input direction and handle the movement/deceleration.
	direction_x = Input.get_axis(inputs[3], inputs[1])
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	direction_y = Input.get_axis(inputs[0], inputs[2])
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

func _input(event):
	if event.is_action_pressed(inputs[11]) && manager.can_runner_switch():
		print("runner switch")
		manager.switch_state()

func take_damage(time:float,points:int):
	slipping(time,points)
	velocity = Vector2.ZERO

func slipping(time:float,points:int):
	manager.give_points_maker(points)
	can_move = false
	timer.start(time)

func _on_timer_timeout():
	can_move = true
