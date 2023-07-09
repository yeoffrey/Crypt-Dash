extends Node2D
# Called when start button is clicked.
func start():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	# Hide the UI.
	var ui = get_node("User Interface")
	ui.hide()

func quit():
	get_tree().quit()
