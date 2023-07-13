extends Node2D

func _ready():
	SoundManager.play("game_finished")



func _on_back_pressed():
	GameSceneManager.switch("menu")
