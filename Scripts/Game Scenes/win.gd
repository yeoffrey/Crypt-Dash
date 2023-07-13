extends Node2D

@onready var label = $Label


func _ready():
	if Globaldata.winner == 1:
		label.text = "Player 1 is the winner!"
	else:
		label.text = "Player 2 is the winner!"
	SoundManager.play("game_finished")

func _on_main_menu_pressed():
	GameSceneManager.switch("menu")

func _on_quit_pressed():
	get_tree().quit()
