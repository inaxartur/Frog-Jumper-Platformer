extends StaticBody2D
class_name LilyPad
var isPointGained : bool = false
var isFloatingLog : bool = false
var playerOnFloatingLog : bool = false

var textures := ["var_1", "var_2", "var_3", "var_4"]
var texturesAmmount : int = textures.size()

func _ready() -> void:
	if(randi_range(0, 100) < 95):
		if(randi_range(0, 1) == 1):
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		match randi_range(0, texturesAmmount-1):
			0:
				$Sprite2D.play(textures[0])
			1:
				$Sprite2D.play(textures[1])
			2:
				$Sprite2D.play(textures[2])
			3:
				$Sprite2D.play(textures[3])
			_:
				print("Tried assigning texture that doesn't exist")
	else:
		isFloatingLog = true
		global_position.x += randi_range(30, 150)
		$Sprite2D.play("var_log")

func _process(delta: float) -> void:
	if(isFloatingLog):
		floating_log()
		

func _on_player_point_area_body_entered(body: Node2D) -> void:
	if(body.name == "Player" && !isPointGained):
		isPointGained = true
		SignalBus.pointGained.emit()

func despawn() -> void:
	SignalBus.lilyPadFree.emit()
	queue_free()

func floating_log() -> void:
	$Sprite2D.position.y = 15
	global_position.x -= 0.15
	if(global_position.x < -230):
		global_position.x = 230 + randi_range(0, 50)

func _on_player_on_lily_pad_area_body_entered(body: Node2D) -> void:
	if (body.has_method("get_is_on_floor")):
		if(bool(body.get_is_on_floor())):
			if(!isFloatingLog):
				$Sprite2D.scale.y = 0.8
				$Sprite2D.position.y = 3
	if (isFloatingLog && body.has_method("get_is_on_floor")):
		body.set_player_on_floating_log(true)

func _on_player_on_lily_pad_area_body_exited(body: Node2D) -> void:
	$Sprite2D.scale.y = 1
	if(!isFloatingLog):
		$Sprite2D.position.y = 0
	if(body.has_method("get_is_on_floor")):
		body.set_player_on_floating_log(false)
