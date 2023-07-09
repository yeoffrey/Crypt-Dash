extends Area2D

@onready var animation_player = $AnimationPlayer
var velocity : Vector2 = Vector2.ZERO

func _ready():
	animation_player.play("rolling")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x = position.x + velocity.x * delta
	position.y = position.y + velocity.y * delta
	var bodies = get_overlapping_bodies()
	for i in bodies.size():
		if bodies[i] is Runner:
			bodies[i].can_move = false
			bodies[i].velocity = velocity
	var pos = get_maze_positon()
	if MazeManager.get_value(pos.x,pos.y) == Enums.TILE_TYPE.WALL:
		boulder_break()

func boulder_break():
	var bodies = get_overlapping_bodies()
	for i in bodies.size():
		if bodies[i] is Runner:
			bodies[i].take_damage(1.5,3)
	queue_free()

func get_maze_positon():
	return Vector2(position.x/16,position.y/16)
