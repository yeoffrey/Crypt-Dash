extends Node

const SOUNDS_NODE_PATH = "/root/Main/Sounds"
const AUDIO_FOLDER_PATH = "res://Audio/"
var audio_paths = []
var audio_names = []

func _ready():
	audio_paths = FileExplorer.traverse_directory(AUDIO_FOLDER_PATH)
	var i = 0
	while i < audio_paths.size():
		if audio_paths[i].get_extension().to_lower() == "import":
			var audio_name = audio_paths[i].get_file().to_lower()
			audio_paths[i] = audio_paths[i].substr(0,audio_paths[i].length()-7)
			audio_name = audio_name.substr(0,audio_name.length()-11)
			audio_names.append(audio_name)
			i += 1
		else:
			audio_paths.remove_at(i)
	
	for j in audio_paths:
		print(j)

func _process(delta):
	close_finished()

func play(audio_name:String,ignore:bool=true):
	for i in audio_names.size():
		if audio_names[i] == audio_name && (!exists(audio_name) || ignore):
			create_audio_player(i)
			return true
	print("Failed at finding audio stream " + audio_name)
	return false


func create_audio_player(index:int):
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = ResourceLoader.load(audio_paths[index]) as AudioStreamWAV
	get_node(SOUNDS_NODE_PATH).add_child(audio_player)
	audio_player.name = audio_names[index]
	audio_player.volume_db = 0.0
	audio_player.play()


func stop_all():
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		i.queue_free()

func stop(child_name:String):
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		if i.name.begins_with(child_name):
			i.queue_free()

func set_volume(val:float):
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		i.volume_db = val

func close_finished():
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		if !i.playing:
			i.queue_free()

func exists(child_name:String):
	var children = get_node(SOUNDS_NODE_PATH).get_children()
	for i in children:
		if i.name.begins_with(child_name):
			return true
		
	return false

