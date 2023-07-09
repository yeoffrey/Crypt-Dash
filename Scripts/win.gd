extends Control

@onready var label = $Label
@onready var sound = $AudioStreamPlayer


func _ready():
	if Globaldata.winner == 1:
		label.text = "Player 1 is the winner!"
	else:
		label.text = "Player 2 is the winner!"
	sound.play()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_pressed():
	get_tree().quit()
