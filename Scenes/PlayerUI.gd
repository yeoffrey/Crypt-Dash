extends Control

@onready var timer_label : Label = $TimerLabel
@onready var timer : Timer = $TimerLabel/Timer
@onready var wall_label : Label = $Wall/WallLabel
@onready var fake_wall_label : Label = $FakeWall/FakeWallLabel
@onready var boulder_label : Label = $Boulder/BoulderLabel
@onready var oil_cooldown : Cooldown = $OilCooldown
@onready var bomb_cooldown : Cooldown = $BombCooldown
@onready var switch_bar = $TextureProgressBar
@onready var color_bar = $Background

