extends Node

var current_scene: Node = null
var scenes: Dictionary = {}

@onready var start_menu_scene = preload("res://Scenes/UI/StartMenuUI.tscn")
@onready var monster_enclosure_scene = preload("res://Scenes/Windows/monster_enclosure.tscn")
@onready var garden_scene = preload("res://Scenes/Windows/garden.tscn")
@onready var alchemy_lab_scene = preload("res://Scenes/Windows/alchemy_lab.tscn")
@onready var expedition_scene = preload("res://Scenes/Windows/expeditions.tscn")
@onready var npc: Control = null
@onready var found_monster: Node2D = null
@onready var scene_spawn_point: Node2D = null
@onready var start_menu: Node = get_node("/root/StartMenu")
@onready var pause_menu: CanvasLayer = null
@onready var main_window = null
@onready var main_ui = null
@onready var quest_ui = null
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
var pending_monsters = []
var player_monsters = []
var spawn_point_index = 0
var spawn_timer: Timer = null
var monster_id_counter: int = 1
var test_monsters = [
	"common_slime",
	#"forest_dinglebat",
	#"common_shrooman",
	#"common_shrooman",
	#"plains_imp",
	#"shallows_jelly",
	#"nekomata",
	#"forest_dinglebat"
]
# Variables for research tasks
var dinglebat_count = 0
var shrooman_count = 0
var plains_imp_present = false
var other_carnivore_present = false
var jelly_count = 0
# Music & Sounds
var sound_effect_stream_player: AudioStreamPlayer2D
var sound_effects: Dictionary = {
	"background_sound0": preload("res://Sounds/Effects/background0.wav"),
	"background_sound1": preload("res://Sounds/Effects/background1.wav"),
	"bubble": preload("res://Sounds/Effects/bubble.wav"),
	"chew0": preload("res://Sounds/Effects/chew0.wav"),
	"chew1": preload("res://Sounds/Effects/chew1.wav"),
	"click": preload("res://Sounds/Effects/click.wav"),
	"drawer": preload("res://Sounds/Effects/drawer.wav"),
	"mission_completed": preload("res://Sounds/Effects/mission_completed.wav"),
	"monster_happy0": preload("res://Sounds/Effects/monster_happy0.wav"),
	"monster_happy1": preload("res://Sounds/Effects/monster_happy1.wav"),
	"monster_sad0": preload("res://Sounds/Effects/monster_sad0.wav"),
	"new_mission": preload("res://Sounds/Effects/new_mission.wav"),
	"plant_complete": preload("res://Sounds/Effects/plant_complete.wav"),
	"walk": preload("res://Sounds/Effects/walk.wav")
}
var first_time_alchemy_lab = true

var first_start = true

func _ready():
	randomize()
	add_main_ui_npc()
	initialise_spawn_timer()
	get_player_monster_data()
	
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
	main_ui.visible = true
	if !first_start:
		quest_ui.visible = true
	get_tree().root.add_child(main_window)
	#print("MainWindow added to the scene tree.")
	
	if start_menu != null:
		start_menu.queue_free()
	
	if first_start:
		PlayerData.load_data()
	
		QuestManager.add_quest("SettlingIn")
		first_start = false
	DayNightCycle.start_time_progression()
	# Ensure NPC updates according to the active quest
	if npc:
		npc.update_npc_sprite_based_on_active_quest()
	
	# Switch to the monster enclosure scene
	change_scene("MonsterEnclosure")
	# Assign found_monster variable after the MonsterEnclosure scene is instantiated
	assign_monster_spawn_locations()
	sound_effect_stream_player = get_node("/root/Header/SoundEffectStreamPlayer")

func add_main_ui_npc():
		# Instantiate and add MainWindow to the scene tree
	var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")
	main_window = main_window_scene.instantiate()
	if main_window == null:
		print("Error: MainWindow failed to instantiate.")
	#else:
		#print("MainWindow instantiated successfully.")
	main_ui = main_window.get_node("UI/MainUI")
	quest_ui = main_window.get_node("UI/Quests")
	main_window.visible = false  # Hide initially
	get_tree().root.add_child(main_window)
	
	npc = main_window.get_node("UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character")
	# Get the PauseMenu node from MainWindow
	pause_menu = main_window.get_node("PauseMenu")
	if pause_menu:
		pause_menu.visible = false

func initialise_spawn_timer():
		# Initialize spawn timer
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0  # 1 sec. delay between spawns
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)

func get_player_monster_data():
	pending_monsters = PlayerData.pending_monsters
	player_monsters = PlayerData.player_monsters
	
	if pending_monsters.size() == 0 and player_monsters.size() > 0:
		print("Loaded player monsters without duplicating pending monsters")
		#pending_monsters = player_monsters.keys()
		#PlayerData.pending_monsters = pending_monsters

func assign_monster_spawn_locations():
	if current_scene and current_scene.name == "MonsterEnclosure":
		# Initialize monster_spawn_locations
		monster_spawn_locations = []
		for i in range(0, 6):
			var spawn_point = current_scene.get_node_or_null("MonsterSpawnPoint%d" % i)
			if spawn_point:
				monster_spawn_locations.append(spawn_point)
			else:
				print("Failed to find MonsterSpawnPoint%d" % i)
	else:
		print("MonsterEnclosure scene not instantiated yet.")

func change_scene(scene_name: String):
	if current_scene == null or scene_name != current_scene.name:
		print("Changing to scene: " + scene_name)
		_close_ui_drawer()
		_goto_scene(scene_name)

func _close_ui_drawer():
	if main_ui != null:
		main_ui.close_inventory_drawer()

func _goto_scene(scene_name: String):
	
	if scene_name == "StartMenu":
		if current_scene != null:
			current_scene.visible = false
		PlayerData.save_data()
		main_ui.visible = false
		if !first_start:
			quest_ui.visible = false
		DayNightCycle.stop_time_progression()
		start_menu = get_node("/root/StartMenu")

		get_tree().root.add_child(start_menu_scene.instantiate())
		scenes[scene_name] = start_menu_scene.instantiate()
		current_scene = scenes[scene_name]
		pause_menu.visible = false
		return
	
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

	if scene_name == "MonsterEnclosure":
		main_ui.visible = true
		assign_monster_spawn_locations()
		
		if pending_monsters.size() > 0:
			spawn_pending_monsters()
		elif player_monsters.size() > 0:
			spawn_player_monsters()
		DayNightCycle.start_time_progression()
	elif scene_name == "AlchemyLab":
		main_ui.visible = true
		DayNightCycle.start_time_progression()
		
		# Check if it's the first time visiting the Alchemy Lab
		if first_time_alchemy_lab:
			first_time_alchemy_lab = false  # Update the flag to prevent future triggers
			if main_ui != null:
				var codex_alert = main_ui.get_node("MainScreen/ScreenBorders/BookShelf/MonsterBook/CodexAlert")
				if codex_alert:
					codex_alert.visible = true  # Make the Codex alert visible
					print("Codex alert is now visible")
				else:
					print("Codex alert node not found")
			else:
				print("Main UI is null")
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
	#PlayerData.pending_monsters = pending_monsters
	#PlayerData.save_data()
	print("Awarded a new monster: ", species_name)

func spawn_pending_monsters():
	if current_scene.name != "MonsterEnclosure":
		print("MonsterEnclosure is not active, wait to spawn pending monsters.")
		return
	if pending_monsters.is_empty():
		print("No pending monsters to spawn")
		return
	assign_monster_spawn_locations()
	if monster_spawn_locations.is_empty():
		print("No spawn locations available.")
		return
	spawn_next_monster()

func spawn_next_monster():
	if pending_monsters.is_empty():
		print("All pending monsters spawned.")
		return
	
	assign_monster_spawn_locations()
	
	var spawn_point = monster_spawn_locations[spawn_point_index % monster_spawn_locations.size()]
	spawn_point_index += 1

	var species_name = pending_monsters.pop_front()
	var monster_scene = monster_scenes.get(species_name, null)
	
	if monster_scene == null:
		print("Unknown species: ", species_name)
		return
	
	var monster_instance = monster_scene.instantiate()
	spawn_point.add_child(monster_instance)
	
	# Assign unique ID to this instantiated monster
	monster_instance.monster_id = monster_id_counter
	monster_id_counter += 1
	
	var monster_data = {
		"monster_id": monster_instance.monster_id,
		"species_name": species_name,
		"hunger_meter": monster_instance.hunger_meter,
		"happiness_meter": monster_instance.happiness_meter,
		"foods_fed": monster_instance.foods_fed
	}
	
	PlayerData.player_monsters[monster_instance.monster_id] = monster_data
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
	
	if species.name == "shallows_jelly":
		jelly_count += 1
		if jelly_count >= 4:
			PlayerData.research_tasks_completed["Shallows Jelly"][0] = true
			PlayerData.save_data()
			print("Research task 'Shallows Jelly' completed")
	# End research tasks check section

	if pending_monsters.size() > 0:
		spawn_timer.start()

func spawn_player_monsters():
	if current_scene.name != "MonsterEnclosure":
		return
	
	assign_monster_spawn_locations()
	
	if monster_spawn_locations.is_empty():
		print("No spawn locations available.")
		return
	
	var index = 0
	for monster_id in PlayerData.player_monsters.keys():
		print("monster_id in playerdata monsters keys: ", monster_id)
		if get_monster_instance_by_id(monster_id) != null:
			print("Monster with ID %d already instantiated. Skipping spawn." % monster_id)
			continue
		
		var monster_data = PlayerData.player_monsters[monster_id]
		var monster_instance = create_monster_from_data(monster_data)
		if monster_instance == null:
			continue
	
		var spawn_point = monster_spawn_locations[index % monster_spawn_locations.size()]
		index += 1
		spawn_point.add_child(monster_instance)
		monster_instance.monster_id = monster_id

func _on_spawn_timer_timeout():
	spawn_next_monster()

func play_sound(sound_effect: String = ""):
	if sound_effect_stream_player and sound_effects.has(sound_effect):
		sound_effect_stream_player.stream = sound_effects[sound_effect]  # Set the stream from the dictionary
		
		if sound_effect_stream_player.stream:  # Ensure the stream is valid
			sound_effect_stream_player.play()
			print("Playing sound: ", sound_effect)
		else:
			print("Error: Sound stream is invalid for effect: ", sound_effect)
	else:
		print("Error: Sound effect not found or sound player not initialized.")

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

func create_monster_from_data(monster_data: Dictionary) -> Node:
	var species_name = monster_data.get("species_name", "")
	
	if species_name == "" or species_name == null:
		print("Error: species_name is missing or invalid.")
		return null
	print("species_name in GameManager create_mons: ", species_name)
	var monster_scene = get_monster_scene_by_species(species_name)
	
	if monster_scene == null:
		print("Unknown monster scene for species: ", species_name)
		return null

	var monster_instance = monster_scene.instantiate()
	
	monster_instance.monster_id = monster_data.get("monster_id", 0)  # Set the unique monster_id
	monster_instance.hunger_meter = monster_data.get("hunger_meter", 5)
	monster_instance.happiness_meter = monster_data.get("happiness_meter", 5)
	monster_instance.foods_fed = monster_data.get("foods_fed", [])
	
	monster_instance.add_to_group("monsters")
	
	return monster_instance

func get_monster_scene_by_species(species_name: String) -> PackedScene:
	print("GameManager: get_monster_scene_by_species called with, ", species_name)
	if monster_scenes.has(species_name):
		print("Species: ", species_name)
		return monster_scenes[species_name]
	else:
		print("Unknown species: ", species_name)
		return null

func spawn_test_monsters():
	for species_name in test_monsters:
		award_monster(species_name)  # Add test monsters to pending monsters
	
	#PlayerData.save_data()  # Save test monsters so they persist across game runs
	print("Test monsters spawned and saved.")

func get_monster_instance_by_id(monster_id: int) -> MonsterBase:
	for monster in get_tree().get_nodes_in_group("monsters"):
		if monster.monster_id == monster_id:
			return monster
	return null

func close_codex():
	main_ui._on_monster_book_pressed()
	print("main_ui: ", main_ui)
