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

func _ready():
	var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")
	main_window = main_window_scene.instantiate()
	if main_window == null:
		print("Error: MainWindow failed to instantiate.")
	else:
		print("MainWindow instantiated successfully.")
	main_ui	 = main_window.get_node("UI/MainUI")
	main_window.visible = false
	get_tree().root.add_child(main_window)
	print("MainWindow added to the scene tree.")
	
	npc = main_window.get_node("UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character")
	# Get the PauseMenu node from MainWindow
	pause_menu = main_window.get_node("PauseMenu")
	if pause_menu:
		pause_menu.visible = false
	
	change_scene("StartMenu")

func start_game():
	# Load and instantiate MainWindow scene
	var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")
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
	
# Method to assign the found_monster variable after the scene is loaded
func assign_found_monster():
	if current_scene:
		found_monster = current_scene.get_node("MonsterSpawnPoint1")  # Adjust path to match your node structure
		if found_monster:
			print("found_monster variable assigned successfully.")
		else:
			print("Failed to find the monster node in MonsterEnclosure.")
	else:
		print("MonsterEnclosure scene not instantiated yet.")

# Change sub scene based on input scene_name
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

	# Check is scene is already loaded, if not, load and add to scene tree.
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
	if scene_name == "MonsterEnclosure":
		main_ui.visible = true
	
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

func play_sound():
	var audio_stream = get_node("/root/Header/MainMusic")
	if audio_stream:
		# Assign sound to play here or in inspector
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
