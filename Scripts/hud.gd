extends CanvasLayer

@onready var pointLabel : Label = $PointCounterLabel

var pointCounter : int = -1

func _ready() -> void:
	SignalBus.pointGained.connect(_on_point_gained)
	pointLabel.text = str(pointCounter)

func _on_point_gained() -> void:
	pointCounter += 1
	pointLabel.text = str(pointCounter)
	
