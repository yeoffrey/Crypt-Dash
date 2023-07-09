extends Node

var maze : Array

var width : int
var height : int 
var end_cell : Vector2
var start_cell : Vector2

var rng = RandomNumberGenerator.new()

func _init(newwidth:int = 21, newheight:int = 21):
	
	maze = Array()
	width = newwidth
	height = newheight
	start_cell = Vector2(width-2,height-2)
	end_cell = Vector2(1,0) 
	
	for i in width:
		var newarray = Array()
		maze.append(newarray)
		for j in height:
				maze[i].append(-1)

func _ready():
	randomize_maze()
	maze[end_cell.x][end_cell.y] = Enums.TILE_TYPE.FLOOR

# Creates a brand new random maze
func randomize_maze():
	for i in width:
		for j in height:
				maze[i][j] = Enums.TILE_TYPE.WALL
	
	var visited_stack : Array
	visited_stack.append(start_cell)
	maze[start_cell.x][start_cell.y] = Enums.TILE_TYPE.FLOOR
	
	while (!visited_stack.is_empty()):
		var neighbor = pick_neighbor(visited_stack.back())
		if (neighbor != Vector2(-1,-1)):
			set_line(visited_stack.back(), neighbor, Enums.TILE_TYPE.FLOOR)
			visited_stack.append(neighbor)
		else:
			visited_stack.pop_back()
	maze[end_cell.x][end_cell.y] = Enums.TILE_TYPE.FLOOR

# Returns a random neighbor distance from cell. Returns the cords or (-1, -1) if fails
func pick_neighbor(cell : Vector2, distance : int = 2):
	
	var neighbors : Array
	var neighbor : Vector2
	
	for i in 4:
		neighbor = get_neighbor(cell, i, distance)
		if neighbor != Vector2(-1,-1) && maze[neighbor.x][neighbor.y] != Enums.TILE_TYPE.FLOOR:
			neighbors.append(neighbor)
	
	if neighbors.is_empty():
		return Vector2(-1,-1)
	return neighbors[rng.randi_range(0,neighbors.size()-1)]

# Returns Vector2 of cell location of neighbor distance away
# 0 = Up, 1 = Right, 2 = Down, 3 = left
func get_neighbor(cell : Vector2, direction : int = 0, distance : int = 2):
	if direction == 0 && cell.y-distance >= 0:
		return Vector2(cell.x,cell.y-distance)
	if direction == 1 && cell.x+distance < width:
		return Vector2(cell.x+distance,cell.y)
	if direction == 2 && cell.y+distance < height:
		return Vector2(cell.x,cell.y+distance)
	if direction == 3 && cell.x-distance >= 0:
		return Vector2(cell.x-distance,cell.y)
	return Vector2(-1,-1)

# Sets a line from to on array to value. If diagonal will do both vertical and horizontal lines
func set_line(from : Vector2, to : Vector2, val : int):
	maze[from.x][from.y] = val
	for i in abs(to.x-from.x):
		if to.x-from.x < 0:
			maze[from.x-i][from.y] = val
		else:
			maze[from.x+i][from.y] = val
	for i in abs(to.y-from.y):
		if to.y-from.y < 0:
			maze[from.x][from.y-i] = val
		else:
			maze[from.x][from.y+i] = val
	maze[to.x][to.y] = val

# Sets value at cell x,y to v. Returns true if successful and false if not
func set_value(x : int, y : int, v : int):
	if (x >= 0 && x <= width-1 && y >= 0 && y <= height-1):
		maze[x][y] = v
		return true
	return false

# Returns value at cell x,y
func get_value(x : int, y : int):
	if (x >= 0 && x <= width-1 && y >= 0 && y <= height-1):
		return maze[x][y]
	return -1

func print_array():
	for i in width:
		print(maze[i])
	print("")

func is_solvable(cell:Vector2):
	
	var open_list : Array
	var closed_list : Array
	open_list.append(Successor.new(cell))
	
	while !(open_list.is_empty()):
		
		var lowest_f = 0
		
		for i in open_list.size():
			if open_list[i].f < open_list[lowest_f].f:
				lowest_f = i
		
		for i in 4:
			var neighbor = Successor.new(get_neighbor(open_list[lowest_f].position,i,1),open_list[lowest_f])
			if maze[neighbor.position.x][neighbor.position.y] == Enums.TILE_TYPE.WALL:
				continue
			if neighbor.position == Vector2(-1,-1):
				continue
			if neighbor.position == end_cell:
				return true
			neighbor.find_f(end_cell)
			var append = true
			for j in open_list.size():
				if open_list[j].position == neighbor.position && open_list[j].f < neighbor.f:
					append = false
			for j in closed_list.size():
				if closed_list[j].position == neighbor.position && closed_list[j].f < neighbor.f:
					append = false
			if append:
				open_list.append(neighbor)
		
		closed_list.append(open_list[lowest_f])
		open_list.remove_at(lowest_f)
	return false
