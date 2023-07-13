extends Node

const SCENE_NODE_PATH = "/root/Main/Scene"
const SCENE_FOLDER_PATH = "res://Scenes/GameScenes"
var scene_paths = []
var scene_names = []

func _ready():
	scene_paths = FileExplorer.traverse_directory(SCENE_FOLDER_PATH)
	var i = 0
	while i < scene_paths.size():
		if scene_paths[i].get_extension().to_lower() == "tscn":
			var scene_name = scene_paths[i].get_file().to_lower()
			scene_name = scene_name.substr(0,scene_name.length()-5)
			scene_names.append(scene_name)
			i += 1
		else:
			scene_paths.remove_at(i)

func switch(scene_name:String):
	for i in scene_names.size():
		if scene_names[i] == scene_name:
			stop_all()
			SoundManager.stop_all()
			load_instance(i)
			return true
	print("Failed at finding Scene " + scene_name)
	return false


func load_instance(index:int):
	var packed_scene = ResourceLoader.load(scene_paths[index]) as PackedScene
	var scene_instance = packed_scene.instantiate()
	scene_instance.position = Vector2(0,0)
	get_node(SCENE_NODE_PATH).add_child(scene_instance)
	scene_instance.name = scene_names[index]
	

func spawn_object(packed_scene:PackedScene,pos:Vector2=Vector2(0,0)):
	var scene_instance = packed_scene.instantiate()
	get_node(SCENE_NODE_PATH).add_child(scene_instance)
	scene_instance.position = pos

func stop_all():
	var children = get_node(SCENE_NODE_PATH).get_children()
	for i in children:
		i.queue_free()

func stop(child_name:String):
	var children = get_node(SCENE_NODE_PATH).get_children()
	for i in children:
		if i.name.begins_with(child_name):
			i.queue_free()

