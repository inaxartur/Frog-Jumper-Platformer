extends Camera2D

const cameraSpeed : float = 0.075

@export var Player : CharacterBody2D

@onready var LilyPadScene : PackedScene = load("res://Scenes/lily_pad.tscn")
var LilyPadNode : Node2D = null
var isPlayerDead : bool = false
var currScore : float = 1

func _ready() -> void:
	LilyPadNode = LilyPadScene.instantiate()

func _process(delta: float) -> void:
	if(!isPlayerDead):
		if(Player.position.y < position.y):
			position.y = Player.position.y
		else:
			position.y -= log(currScore) * cameraSpeed

func _on_game_over_area_body_entered(body: Node2D) -> void:	
	print(body)
	if(body.name.begins_with("LilyPad")):
		body.despawn()
		currScore += 1
	elif(body.name == "Player"):
		print("GAME OVER")
		isPlayerDead = true
		Player.die()


func _on_game_over_area_area_entered(area: Area2D) -> void:
	print(area)
	if(area.name.begins_with("Background")):
		SignalBus.moveBackground.emit()
