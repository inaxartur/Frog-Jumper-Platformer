extends CanvasLayer

@onready var pointLabel : Label = $PointCounterLabel

var json_path = "res://highscore.json"

var pointCounter : int = -1
var highScore : Dictionary = {
	"highscore": 0
}

func _ready() -> void:
	SignalBus.pointGained.connect(_on_point_gained)
	SignalBus.playerDied.connect(_on_player_die)
	pointLabel.text = str(pointCounter)
	highScore = load_json_file()


func _on_point_gained() -> void:
	pointCounter += 1
	if(pointCounter > highScore.get("highscore")):
		highScore.set("highscore", pointCounter)
	pointLabel.text = "Highest Score: " + str(int(highScore.get("highscore"))) + "\n" + str(pointCounter)

func _on_player_die() -> void:
	if(pointCounter == highScore.get("highscore")):
		write_json_file(highScore)

func load_json_file():
	var file = FileAccess.open(json_path, FileAccess.READ)
	assert(file.file_exists(json_path), "File path does not exists.")
	
	var json = file.get_as_text()
	var json_object = JSON.new()
	
	json_object.parse(json)
	highScore = json_object.data
	
	return highScore

func write_json_file(data: Dictionary):
	print("Writing to json")
	var file = FileAccess.open(json_path, FileAccess.ModeFlags.WRITE)
	
	if file:
		var json_text = JSON.stringify(data, "\t")
		file.store_string(json_text)
	else:
		print("Failed to open or create the file.")
