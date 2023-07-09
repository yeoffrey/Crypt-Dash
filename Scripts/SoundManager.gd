extends Node2D

@onready var boulder_rolling = $BoulderRolling
@onready var boulder_crash = $BoulderCrash
@onready var buzzer = $Buzzer
@onready var explosion = $Explosion
@onready var oil = $Oil
@onready var footsteps = $Footsteps
@onready var winner = $Winner
@onready var place_thing = $PlaceThing
@onready var fake_disappears = $FakeDisappears
@onready var reverse = $Reverse
@onready var pickup = $Pickup

func play_boulder_rolling():
	if !boulder_rolling.playing:
		boulder_rolling.play()

func stop_boulder_rolling():
	boulder_rolling.stop()

func play_boulder_crash():
	if !boulder_crash.playing:
		boulder_crash.play()

func play_buzzer():
	buzzer.play()

func play_explosion():
	if !explosion.playing:
		explosion.play()

func play_oil():
	if !oil.playing:
		oil.play()

func stop_oil():
	oil.stop()

func play_footsteps():
	if !footsteps.playing:
		footsteps.play()

func stop_footsteps():
	footsteps.stop()

func play_winner():
	if !winner.playing:
		winner.play()

func play_place_thing():
	place_thing.play()

func play_fake_disappears():
	if !fake_disappears.playing:
		fake_disappears.play()

func play_reverse():
	reverse.play()

func play_pickup():
	pickup.play()
