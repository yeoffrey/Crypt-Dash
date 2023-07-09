extends Area2D

var type : int = 0
var manager : GameManager
@onready var sprite : Sprite2D = $Sprite2D

func set_type(ntype):
	type = ntype
	if type == 0:
		sprite.frame = 0
	else:
		sprite.frame = 4

func _process(delta):
	hide()
	for i in manager.maze_map.view.size():

		if floor(position/16) == manager.maze_map.view[i]:
			show()
	

func _on_body_entered(body):
	manager.give_pickup(type)
	queue_free()
