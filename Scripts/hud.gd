extends CanvasLayer

@onready var pointLabel : Label = $PointCounterLabel

const JSON_PATH_HIGHSCORE = "res://highscore.json"

var pointCounter : int = 0
var highScore : Dictionary = {
	"highscore": 0
}

func _ready() -> void:
	SignalBus.pointGained.connect(_on_point_gained)
	SignalBus.playerDied.connect(_on_player_die)
	pointLabel.text = str(pointCounter)
	highScore = load_json_file()
	pointLabel.text = "Highscore: " + str(int(highScore.get("highscore"))) + "\n" + str(pointCounter)


func _on_point_gained() -> void:
	pointCounter += 1
	if(pointCounter > highScore.get("highscore")):
		highScore.set("highscore", pointCounter)
	pointLabel.text = "Highscore: " + str(int(highScore.get("highscore"))) + "\n" + str(pointCounter)

func _on_player_die() -> void:
	if(pointCounter == highScore.get("highscore")):
		write_json_file(highScore)

func load_json_file():
	var file = FileAccess.open(JSON_PATH_HIGHSCORE, FileAccess.READ)
	assert(file.file_exists(JSON_PATH_HIGHSCORE), "File path does not exists.")
	
	var json = file.get_as_text()
	var json_object = JSON.new()
	
	json_object.parse(json)
	highScore = json_object.data
	
	return highScore

func write_json_file(data: Dictionary):
	print("Writing to json")
	var file = FileAccess.open(JSON_PATH_HIGHSCORE, FileAccess.ModeFlags.WRITE)
	
	if file:
		var json_text = JSON.stringify(data, "\t")
		file.store_string(json_text)
	else:
		print("Failed to open or create the file.")
