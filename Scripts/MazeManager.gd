extends Node

var array : Array
var width : int
var height : int
var start_cell : Vector2
var end_cell : Vector2

func _init(newwidth:int = 20, newheight:int = 20):
	array = Array()
	width = newwidth
	height = newheight
	start_cell = Vector2(width-2,height-2)
	end_cell = Vector2(1,0)
	for i in width:
		var newarray = Array()
		array.append(newarray)
		for j in height:
			if (i == 0 || i == 19 || j == 0 || j == 19):
				array[i].append(1)
			else:
				array[i].append(0)
	start_cell = Vector2(width-2,height-2)
	array[start_cell.x][start_cell.y] = 2
	array[end_cell.x][end_cell.y] = 3

func set_value(width : int, height : int, value : int):
	if (width >= 0 && width <= 19 && height >= 0 && height <= 19):
		array[width][height] = value
		return true
	return false

func get_value(width : int, height : int):
	if (width >= 0 && width <= 19 && height >= 0 && height <= 19):
		return array[width][height]
	return -1

func print_array():
	for i in width:
		print(array[i])
	print("")
