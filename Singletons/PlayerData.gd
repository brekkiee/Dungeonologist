extends Node

const SAVE_FILE_PATH = "user://player_data.save"

var research_tasks_completed = {
	"Common Slime": [false, false, false],
	"Forest Dinglebat": [false, false, false],
	"Common Shrooman": [false, false, false],
	"Plains Imp": [false, false, false],
	"Shallows Jelly": [false, false, false],
	"Nekomata": [false, false, false]
}

var time_mode = "In-Game Time"  # Default time mode
var current_time: float = 0.0
var is_day: bool = true
var day_count: int = 1
var player_monsters = {}
var pending_monsters = []

func _ready():
	load_data()

func set_time_mode(mode):
	time_mode = mode
	save_data()

func get_time_mode():
	return time_mode

func save_data():
	var monster_data = {}
	for monster in player_monsters.values():
		print("species_name in save_data()", monster.get("species_name"))
		monster_data[monster.monster_id] = {
			"monster_id": monster.monster_id,
			"species_name": monster.get("species_name"),
			"hunger_meter": monster.hunger_meter,
			"happiness_meter": monster.happiness_meter,
			"foods_fed": monster.foods_fed
		}
	
	var data = {
		"research_tasks_completed": research_tasks_completed,
		"time_mode": time_mode,
		"current_time": current_time,
		"is_day": is_day,
		"day_count": day_count,
		"player_monsters": monster_data,
		"pending_monsters": pending_monsters
	}
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if save_file:
		save_file.store_var(data)
		save_file.close()
		print("Data saved successfully to ", SAVE_FILE_PATH)
		print("research_tasks_completed: ", research_tasks_completed)
		print("time_mode: ", time_mode)
		print("current_time: ", current_time)
		print("is_day: ", is_day)
		print("day_count: ", day_count)
		print("player_monsters: ", player_monsters)
		print("pending_monsters: ", pending_monsters)
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
			pending_monsters = data.get("pending_monsters", [])
			
			player_monsters.clear()
			var loaded_monsters = data.get("player_monsters", {})
			
			for monster_id in loaded_monsters.keys():
				print("loaded_monster.keys(): ", loaded_monsters.keys())
				var monster_info = loaded_monsters[monster_id]
				print("monster_info: ", monster_info)
				var monster = GameManager.create_monster_from_data(monster_info)
				if monster_info.has("species_name"):
					monster.set("species_name", monster_info["species_name"])
				player_monsters[monster_id] = monster_info
			
			save_file.close()
			print("Data loaded successfully from ", SAVE_FILE_PATH)
			print("Data saved successfully to ", SAVE_FILE_PATH)
			print("research_tasks_completed: ", research_tasks_completed)
			print("time_mode: ", time_mode)
			print("current_time: ", current_time)
			print("is_day: ", is_day)
			print("day_count: ", day_count)
			print("player_monsters: ", player_monsters)
			print("pending_monsters: ", pending_monsters)
		else:
			print("Failed to open save file for reading.")
	else:
		print("Save file does not exist. Starting with default data.")
		GameManager.spawn_test_monsters()
		print("spawn test monsters from PlayerData")
