extends Node2D

func _ready():
	SoundManager.play("fire")

func _on_quit_pressed():
	get_tree().quit()

func _on_instructions_pressed():
	GameSceneManager.switch("instructions")

func _on_credits_pressed():
	GameSceneManager.switch("credits")

func _on_play_pressed():
	GameSceneManager.switch("game")
