extends Area2D

func _ready() -> void:
	SignalBus.moveBackground.connect(_move_background)

func _move_background() -> void:
	global_position.y -= 960
