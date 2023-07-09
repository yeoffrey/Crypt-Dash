extends Area2D


@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_body_entered(body):
	show()
	body.slipping(1.0,1)
	body.velocity = body.velocity * 0.6
	timer.start(1.0)


func _on_timer_timeout():
	queue_free()
