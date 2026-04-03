extends StaticBody2D

var isPointGained : bool = false



func _on_player_point_area_body_entered(body: Node2D) -> void:
	if(body.name == "Player" && !isPointGained):
		isPointGained = true
		print("point gaiend")
		SignalBus.pointGained.emit()
