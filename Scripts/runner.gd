extends CharacterBody2D

@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]

const SPEED = 100.0
var x_direction = Vector2.ZERO
var y_direction = Vector2.ZERO

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	x_direction = Input.get_axis("left", "right")
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	y_direction = Input.get_axis("up", "down")
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()
	update_animation()

func update_animation():
	if (Input.is_action_pressed("up") || Input.is_action_pressed("left") || Input.is_action_pressed("right") || Input.is_action_pressed("down")):
		animation_tree.set("parameters/idle/blend_position", Vector2(x_direction, -y_direction))
		animation_tree.set("parameters/running/blend_position", Vector2(x_direction, -y_direction))
	if velocity != Vector2.ZERO:
		playback.travel("running")
	else:
		playback.travel("idle")

