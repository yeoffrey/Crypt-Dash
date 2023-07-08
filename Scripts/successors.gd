class_name Successor

var parent : Successor
var position : Vector2
var h : int
var g : int
var f : int

func _init(newposition : Vector2,newparent:Successor = null):
	parent = newparent
	position = newposition
	h = 0
	g = 0
	f = 0

func find_f(end_pos):
	g = 1 + parent.g
	h = abs(position.x - end_pos.x) + abs(position.y - end_pos.y)
	f = g + h
	return f
