extends Node

var current_scene: Node = null
var scenes: Dictionary = {}

@onready var start_menu_scene = preload("res://Scenes/Windows/start_menu.tscn")
@onready var monster_enclosure_scene = preload("res://Scenes/Windows/monster_enclosure.tscn")
@onready var garden_scene = preload("res://Scenes/Windows/garden.tscn")
@onready var alchemy_lab_scene = preload("res://Scenes/Windows/alchemy_lab.tscn")
@onready var expedition_scene = preload("res://Scenes/Windows/expeditions.tscn")

@onready var npc: Control = null
@onready var found_monster: Node2D = null
@onready var scene_spawn_point: Node2D = null
@onready var start_menu: Node = get_node("/root/StartMenu")
@onready var pause_menu: Control = null
@onready var main_window = null
@onready var main_ui = null

# Monster resources
var monster_scenes = {
	"common_slime": preload("res://Assets/Monsters/monster_common_slime.tscn"),
	"forest_dinglebat": preload("res://Assets/Monsters/monster_forest_dinglebat.tscn"),
	"common_shrooman": preload("res://Assets/Monsters/monster_common_shrooman.tscn"),
	"plains_imp": preload("res://Assets/Monsters/monster_plains_imp.tscn"),
	"shallows_jelly": preload("res://Assets/Monsters/monster_shallows_jelly.tscn"),
	"nekomata": preload("res://Assets/Monsters/monster_nekomata.tscn")
}
var monster_spawn_locations = []
var monsters_to_spawn = [
	"common_slime",
	"forest_dinglebat",
	"common_shrooman",
	"plains_imp",
	"shallows_jelly",
	"nekomata"
]
var pending_monsters = []
var player_monsters = []
var spawn_point_index = 0
var spawn_timer: Timer = null

# Variables for research tasks
var dinglebat_count = 0
var shrooman_count = 0
var plains_imp_present = false
var other_carnivore_present = false

func _ready():
	randomize()
	# Instantiate and add MainWindow to the scene tree
	var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")
	main_window = main_window_scene.instantiate()
	if main_window == null:
		print("Error: MainWindow failed to instantiate.")
	else:
		print("MainWindow instantiated successfully.")
	main_ui = main_window.get_node("UI/MainUI")
	main_window.visible = false  # Hide initially
	get_tree().root.add_child(main_window)
	print("MainWindow added to the scene tree.")
	
	npc = main_window.get_node("UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character")
	# Get the PauseMenu node from MainWindow
	pause_menu = main_window.get_node("PauseMenu")
	if pause_menu:
		pause_menu.visible = false
	
	# Initialize spawn timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0  # 1 sec. delay between spawns
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)
	
	pending_monsters = PlayerData.pending_monsters
	player_monsters = PlayerData.player_monsters
	
	# Get the StartMenu node
	start_menu = get_node("/root/StartMenu")
	
	change_scene("StartMenu")

func start_game():
	# Load and instantiate MainWindow scene
	var _main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")
	npc = main_window.get_node("UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character")
	
	if main_window == null:
		print("Error: MainWindow failed to load")
		return
		
	main_window.visible = true
	get_tree().root.add_child(main_window)
	print("MainWindow added to the scene tree.")
	
	if start_menu != null:
		start_menu.queue_free()
	
	QuestManager.add_quest("SettlingIn")
	# Ensure NPC updates according to the active quest
	if npc:
		npc.update_npc_sprite_based_on_active_quest()
	
	# Switch to the monster enclosure scene
	change_scene("MonsterEnclosure")
	# Assign found_monster variable after the MonsterEnclosure scene is instantiated
	assign_found_monster()
	
#	# Start time progression
#	DayNightCycle.start_time_progression()

func assign_found_monster():
	if current_scene and current_scene.name == "MonsterEnclosure":
		# Initialize monster_spawn_locations
		monster_spawn_locations = []
		for i in range(0, 6):
			var spawn_point = current_scene.get_node_or_null("MonsterSpawnPoint%d" % i)
			if spawn_point:
				monster_spawn_locations.append(spawn_point)
				print("Found MonsterSpawnPoint%d" % i)
			else:
				print("Failed to find MonsterSpawnPoint%d" % i)
		print("Monster spawn locations initialized.")
	else:
		print("MonsterEnclosure scene not instantiated yet.")

func change_scene(scene_name: String):
	if current_scene == null or scene_name != current_scene.name:
		print("Changing to scene: " + scene_name)
		_goto_scene(scene_name)

func _goto_scene(scene_name: String):
	scene_spawn_point = get_node("/root/Header/SceneLoadPoint")

	if scene_spawn_point == null:
		print("Can't load scene - SceneLoadPoint not found")
		return

	# Hide the current scene if any
	if current_scene != null:
		current_scene.visible = false

	# Check if scene is already loaded, if not, load and add to scene tree
	if !scenes.has(scene_name):
		var new_scene = _instantiate_scene(scene_name)
		if new_scene:
			scenes[scene_name] = new_scene
			scene_spawn_point.add_child(new_scene)
			print("Scene added: " + new_scene.name)
		else:
			print("Error: Scene instantiation failed for: " + scene_name)
			return
	else:
		current_scene = scenes[scene_name]
		current_scene.visible = true
		print("Using cached scene: " + current_scene.name)

	current_scene = scenes[scene_name]
	print("Scene switched to: " + current_scene.name)

	if scene_name == "StartMenu":
		main_ui.visible = false
		DayNightCycle.stop_time_progression()
	elif scene_name == "MonsterEnclosure":
		main_ui.visible = true
		assign_found_monster()
		spawn_player_monsters()
		spawn_pending_monsters()
		DayNightCycle.start_time_progression()
	else:
		main_ui.visible = true
		DayNightCycle.start_time_progression()

func _instantiate_scene(scene_name: String) -> Node:
	match scene_name:
		"StartMenu": return start_menu_scene.instantiate()
		"Expeditions": return expedition_scene.instantiate()
		"AlchemyLab": return alchemy_lab_scene.instantiate()
		"MonsterEnclosure": return monster_enclosure_scene.instantiate()
		"Garden": return garden_scene.instantiate()
		_:
			print("Unknown scene name: " + scene_name)
			return null

func award_monster(species_name):
	pending_monsters.append(species_name)
	PlayerData.pending_monsters = pending_monsters
	PlayerData.save_data()
	print("Awarded a new monster: ", species_name)

func spawn_pending_monsters():
	if current_scene.name != "MonsterEnclosure":
		print("MonsterEnclosure is not active, wait to spawn pending monsters.")
		return
	if pending_monsters.is_empty():
		print("No pending monsters to spawn")
		return
	assign_found_monster()
	if monster_spawn_locations.is_empty():
		print("No spawn locations available.")
		return
	spawn_next_monster()

func spawn_next_monster():
	if pending_monsters.is_empty():
		print("All pending monsters spawned.")
		return
	var spawn_point = monster_spawn_locations[spawn_point_index % monster_spawn_locations.size()]
	spawn_point_index += 1

	var species_name = pending_monsters.pop_front()
	var monster_scene = monster_scenes.get(species_name, null)
	if monster_scene == null:
		print("Unknown species: ", species_name)
		return
	var monster_instance = monster_scene.instantiate()
	spawn_point.add_child(monster_instance)
	player_monsters.append(species_name)
	PlayerData.player_monsters = player_monsters
	PlayerData.pending_monsters = pending_monsters
	PlayerData.save_data()

	# Research tasks check section
	var species = monster_instance.species
	if species.name == "forest_dinglebat":
		dinglebat_count += 1
		if dinglebat_count >= 2:
			PlayerData.research_tasks_completed["Forest Dinglebat"][0] = true
			PlayerData.save_data()
			print("Research task 'Forest Dinglebat' completed")
	if species.name == "common_shrooman":
		shrooman_count += 1
		if shrooman_count >= 2:
			PlayerData.research_tasks_completed["Common Shrooman"][0] = true
			PlayerData.save_data()
			print("Research task 'Common Shrooman' completed")

	if species.name == "plains_imp":
		plains_imp_present = true
	elif species.is_carnivore:
		other_carnivore_present = true

	if plains_imp_present and other_carnivore_present:
		PlayerData.research_tasks_completed["Plains Imp"][0] = true
		PlayerData.save_data()
		print("Research task 'Plains Imp' completed")

	if species.name == "nekomata":
		PlayerData.research_tasks_completed["Nekomata"][0] = true
		PlayerData.save_data()
		print("Research task 'Nekomata' completed")
	# End research tasks check section

	if pending_monsters.size() > 0:
		spawn_timer.start()

func spawn_player_monsters():
	if current_scene.name != "MonsterEnclosure":
		return
	assign_found_monster()
	if monster_spawn_locations.is_empty():
		print("No spawn locations available.")
		return

	var index = 0
	for species_name in player_monsters:
		var monster_scene = monster_scenes.get(species_name, null)
		if monster_scene == null:
			print("Unknown species: ", species_name)
			continue
		var monster_instance = monster_scene.instantiate()
		var spawn_point = monster_spawn_locations[index % monster_spawn_locations.size()]
		index += 1
		spawn_point.add_child(monster_instance)

func _on_spawn_timer_timeout():
	spawn_next_monster()

func play_sound():
	var audio_stream = get_node("/root/Header/MainMusic")
	if audio_stream:
		audio_stream.stream = load("res://Sounds/ToolSuccessSound.wav")
		audio_stream.play()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		# Unpause the game
		get_tree().paused = false
		if pause_menu:
			pause_menu.visible = false
	else:
		# Pause the game
		get_tree().paused = true
		if pause_menu:
			pause_menu.visible = true
