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

func _ready():
	load_data()

func save_data():
	var save_file = FileAccess.open("SAVE_FILE_PATH", FileAccess.WRITE)
	if save_file:
		save_file.store_var(research_tasks_completed)
		save_file.close()
		print("Data saved successfully to ", SAVE_FILE_PATH)
	else:
		print("Failed to open save file for writing.")

func load_data():
	if FileAccess.file_exists("SAVE_FILE_PATH"):
		var save_file = FileAccess.open("SAVE_FILE_PATH", FileAccess.READ)
		if save_file:
			research_tasks_completed = save_file.get_var()
			save_file.close()
			print("Data loaded successfully from ", SAVE_FILE_PATH)
		else:
			print("Failed to open save file for reading.")
	else:
		print("Save file does not exist. Starting with default data.")
