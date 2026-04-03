extends Camera2D

const cameraSpeed : float = 0.05

@export var Player : CharacterBody2D

func _process(delta: float) -> void:
	if(Player.position.y < position.y):
		position.y = Player.position.y
	else:
		position.y -= cameraSpeed 

func _on_game_over_area_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
		print("GAME OVER")
		Player.die()
