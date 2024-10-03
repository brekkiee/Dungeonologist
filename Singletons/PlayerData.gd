extends Node

const SAVE_FILE_PATH = "player_data.save"

var research_tasks_completed = {
	"Common Slime": [false, false, false],
	"Forest Dinglebat": [false, false, false],
	"Common Shrooman": [false, false, false],
	"Plains Imp": [false, false, false],
	"Shallows Jelly": [false, false, false],
	"Nekomata": [false, false, false]
}

var time_mode = "In-Game Time" # Default time mode
var current_time: float = 00.0
var is_day: bool = true
var day_count: int = 1
var player_monsters = []

func _ready():
	load_data()

func set_time_mode(mode):
	time_mode = mode
	save_data()

func get_time_mode():
	return time_mode

func save_data():
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file:
		var data = {
			"research_tasks_completed": research_tasks_completed,
			"time_mode": time_mode,
			"current_time": current_time,
			"is_day": is_day,
			"day_count": day_count,
			"player_monsters": player_monsters
		}
		save_file.store_var(data)
		save_file.close()
		print("Data saved successfully to ", SAVE_FILE_PATH)
		print("research tasks: ", research_tasks_completed)
		print("time_mode: ", time_mode)
		print("current_time: ", current_time)
		print("is_day: ", is_day)
		print("day_count: ", day_count)
		print("player_monsters: ", player_monsters)
	else:
		print("Failed to open save file for writing.")

func load_data():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if save_file:
			var data = save_file.get_var()
			research_tasks_completed = data.get("research_tasks_completed", research_tasks_completed)
			time_mode = data.get("time_mode", "In-Game Time")
			current_time = data.get("current_time", 0.0)
			is_day = data.get("is_day", true)
			day_count = data.get("day_count", 1)
			player_monsters = data.get("player_monsters", [])
			save_file.close()
			print("Data loaded successfully from ", SAVE_FILE_PATH)
			print("research tasks: ", research_tasks_completed)
			print("time_mode: ", time_mode)
			print("current_time: ", current_time)
			print("is_day: ", is_day)
			print("day_count: ", day_count)
			print("player_monsters: ", player_monsters)
		else:
			print("Failed to open save file for reading.")
	else:
		print("Save file does not exist. Starting with default data.")
