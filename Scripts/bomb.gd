extends Area2D


@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_body_entered(body):
	show()
	animation_player.play("bomb")

func _on_area_2d_body_entered(body):
	body.take_damage(1.0,2)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "bomb":
		animation_player.play("explosion")
	if anim_name == "explosion":
		queue_free()
