extends StaticBody2D
class_name LilyPad
var isPointGained : bool = false

var textures := [load("res://Sprites/LilyPadVar_1.png"), load("res://Sprites/LilyPadVar_2.png"), 
load("res://Sprites/LilyPadVar_3.png"), load("res://Sprites/LilyPadVar_4.png")]
var texturesAmmount : int = textures.size()

func _ready() -> void:
	if(randi_range(0, 1) == 1):
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	match randi_range(0, texturesAmmount-1):
		0:
			$Sprite2D.texture = textures[0]
		1:
			$Sprite2D.texture = textures[1]
		2:
			$Sprite2D.texture = textures[2]
		3:
			$Sprite2D.texture = textures[3]
		_:
			print("Tried assigning texture that doesn't exist")

func _on_player_point_area_body_entered(body: Node2D) -> void:
	if(body.name == "Player" && !isPointGained):
		isPointGained = true
		SignalBus.pointGained.emit()

func despawn() -> void:
	SignalBus.lilyPadFree.emit()
	queue_free()
