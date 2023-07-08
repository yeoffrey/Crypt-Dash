extends Node

var array : Array
var width : int
var height : int
var start_cell : Vector2
var end_cell : Vector2

var rng = RandomNumberGenerator.new()


func _init(newwidth:int = 21, newheight:int = 21):
	array = Array()
	width = newwidth
	height = newheight
	start_cell = Vector2(width-3,height-3)
	end_cell = Vector2(1,0)
	for i in width:
		var newarray = Array()
		array.append(newarray)
		for j in height:
				array[i].append(0)
	start_cell = Vector2(width-2,height-2)
	array[end_cell.x][end_cell.y] = 3
	randomize_maze()

func randomize_maze():
	var visited_stack : Array
	visited_stack.append(start_cell)
	array[start_cell.x][start_cell.y] = 3
	
	while (!visited_stack.is_empty()):
		var neighbor = pick_neighbor(visited_stack.back())
		if (neighbor != Vector2(-1,-1)):
			set_line(visited_stack.back(), neighbor)
			visited_stack.append(neighbor)
		else:
			visited_stack.pop_back()
		





func pick_neighbor(cell : Vector2):
	if !(cell.x+2 < width-1 && array[cell.x+2][cell.y] != 3) && !(cell.x-2 > 0 && array[cell.x-2][cell.y] != 3)  && !(cell.y+2 < height-1 && array[cell.x][cell.y+2] != 3) && !(cell.y-2 > 0 && array[cell.x][cell.y-2] != 3):
		return Vector2(-1,-1)
	var ran = rng.randi_range(0,3)
	while(true):
		if (ran == 0 && (cell.x+2 < width-1 && array[cell.x+2][cell.y] != 3)):
			return Vector2(cell.x+2,cell.y)
		if (ran == 1 && (cell.x-2 > 0 && array[cell.x-2][cell.y] != 3)):
			return Vector2(cell.x-2,cell.y)
		if (ran == 2 && (cell.y+2 < height-1 && array[cell.x][cell.y+2] != 3)):
			return Vector2(cell.x,cell.y+2)
		if (ran == 3 && (cell.y-2 > 0 && array[cell.x][cell.y-2] != 3)):
			return Vector2(cell.x,cell.y-2)
		ran = rng.randi_range(0,3)

func set_line(from : Vector2, to : Vector2,):
	array[from.x][from.y] = 3
	array[to.x][to.y] = 3
	for i in abs(to.x-from.x):
		if to.x-from.x < 0:
			array[from.x-i][from.y] = 3
		else:
			array[from.x+i][from.y] = 3
	for i in abs(to.y-from.y):
		if to.y-from.y < 0:
			array[from.x][from.y-i] = 3
		else:
			array[from.x][from.y+i] = 3

func set_value(width : int, height : int, value : int):
	if (width >= 0 && width <= self.width-1 && height >= 0 && height <= self.height-1):
		array[width][height] = value
		return true
	return false

func get_value(width : int, height : int):
	if (width >= 0 && width <= self.width-1 && height >= 0 && height <= self.height-1):
		return array[width][height]
	return -1

func print_array():
	for i in width:
		print(array[i])
	print("")
