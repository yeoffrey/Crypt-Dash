extends Node2D

var manager : GameManager
@export var boulder : PackedScene

var speed : int = 60

func spawn_boulder(velocity:Vector2):
	var boulder_instance = boulder.instantiate()
	get_parent().call_deferred("add_child",boulder_instance)
	boulder_instance.position = position
	boulder_instance.velocity = velocity
	MazeManager.set_value(position.x/16,position.y/16, Enums.TILE_TYPE.FLOOR)
	boulder_instance.manager = manager
	SoundManager.play("boulder_rolling", false)
	queue_free()

func _on_west_body_entered(body):
	spawn_boulder(Vector2(-speed,0))

func _on_east_body_entered(body):
	spawn_boulder(Vector2(speed,0))

func _on_north_body_entered(body):
	spawn_boulder(Vector2(0,-speed))

func _on_south_body_entered(body):
	spawn_boulder(Vector2(0,speed))
