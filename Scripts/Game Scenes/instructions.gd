extends Node2D

func _ready():
	SoundManager.play("maze_music")

func _on_back_pressed():
	GameSceneManager.switch("menu")
