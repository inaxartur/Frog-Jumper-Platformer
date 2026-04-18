extends Node

const LILY_PAD_DISTANCE : int = 60

var lastLilyPadHeight : int = 0
var lilyPadCurrAmmount : int = 15


@onready var LilyPadScene : PackedScene = load("res://Scenes/lily_pad.tscn")

func _ready() -> void:
	SignalBus.lilyPadFree.connect(_on_lilypad_free)

func _process(delta: float) -> void:
	if(lilyPadCurrAmmount > 0):
		spawn()
		lilyPadCurrAmmount -= 1

func spawn() -> void:
	var LilyPadNode : Node2D = LilyPadScene.instantiate()
	add_child(LilyPadNode)
	LilyPadNode.global_position.y = lastLilyPadHeight - LILY_PAD_DISTANCE - randi_range(0, 0)
	LilyPadNode.global_position.x = randi_range(-100, 100)
	LilyPadNode.name = "LilyPad"
	lastLilyPadHeight = LilyPadNode.global_position.y

func _on_lilypad_free() -> void:
	lilyPadCurrAmmount += 1
