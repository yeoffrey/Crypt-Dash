extends CharacterBody2D

class_name Runner

@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]

const SPEED : float = 100.0
var direction_x : int
var direction_y : int

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	update_velocity()
	move_and_slide()
	update_animation()

func update_animation():
	if (Input.is_action_pressed("up") || Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down")):
		animation_tree.set("parameters/idle/blend_position", Vector2(direction_x, -direction_y))
		animation_tree.set("parameters/running/blend_position", Vector2(direction_x, -direction_y))
	if velocity != Vector2.ZERO:
		playback.travel("running")
	else:
		playback.travel("idle")

func update_velocity():
	# Get the input direction and handle the movement/deceleration.
	direction_x = Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	direction_y = Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
