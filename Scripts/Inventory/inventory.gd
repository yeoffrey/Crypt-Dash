class_name Inventory

var fake_wall : int = 1
var oil : bool = true
var bomb : bool = true
var boulder : int = 1

var oil_cooldown : Cooldown
var bomb_cooldown : Cooldown

func _init(oil_cd, bomb_cd):
	oil_cooldown = oil_cd
	bomb_cooldown = bomb_cd

func place_fake_wall():
	fake_wall -= 1

func place_oil():
	oil = false
	oil_cooldown.start(3.0)

func place_bomb():
	bomb = false
	bomb_cooldown.start(5.0)

func place_boulder():
	boulder -= 1

