extends ColorRect

class_name Cooldown

@onready var timer = $Timer
@onready var progress = $Progress

var cooldown_time = 5.0
func _ready():
	hide()

func start(time:float):
	cooldown_time = time
	timer.start(cooldown_time)
	show()

func stop():
	hide()

func _process(delta):
	progress.value = int(100 - (timer.time_left/cooldown_time * 100))

func _on_timer_timeout():
	stop()
