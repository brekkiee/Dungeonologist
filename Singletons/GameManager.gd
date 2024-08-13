extends Node

var current_scene = null
var scenes = {}
@onready var home_scene = preload("res://Scenes/Windows/home.tscn")
@onready var alchemy_lab_scene = preload("res://Scenes/Windows/alchemy_lab.tscn")
@onready var monster_enclosure_scene = preload("res://Scenes/Windows/monster_enclosure.tscn")
@onready var garden_scene = preload("res://Scenes/Windows/garden.tscn")

@onready var npc: Control = get_node("/root/Header/UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character/")
var spawned_monster: Node2D = null
var monster_spawn_point: Node2D

func _ready():
	start_game()

func start_game():
	QuestManager.addQuest("TutorialQuest")
	call_deferred("_deferred_goto_scene", "Home")

# Change sub scene based on input scene_name
func change_scene(scene_name: String):
	print("Change scene called: " + scene_name)
	if scene_name != current_scene.name:
		print("Scene names are different, proceeding with change scene...")
		call_deferred("_deferred_goto_scene", scene_name)

func _deferred_goto_scene(scene_name: String):
	var scene_spawn_point = get_node("/root/Header/SceneLoadPoint")
	if not scene_spawn_point:
		print("Can't load scene - SceneLoadPoint not found")
	else:
		print("SceneLoadPoint found: ", scene_spawn_point)

	print("Changing Scene")
	print("Scene Spawn Point Children Before: ", scene_spawn_point.get_child_count())
	
	# Hide the current scene if any
	if current_scene != null:
		current_scene.visible = false
		print("Hiding current scene: " + current_scene.name)

	# Check is scene is already loaded, if not, load and add to scene tree.
	var new_scene
	if !scenes.has(scene_name):
		print("Instantiating new scene: " + scene_name)
		match scene_name:
			"Home":
				new_scene = home_scene.instantiate()
				print("Instantiated scene: ", new_scene)
			"AlchemyLab":
				new_scene = alchemy_lab_scene.instantiate()
				print("Instantiated scene: ", new_scene)
			"MonsterEnclosure":
				new_scene = monster_enclosure_scene.instantiate()
				print("Instantiated scene: ", new_scene)
			"Garden":
				new_scene = garden_scene.instantiate()
				print("Instantiated scene: ", new_scene)

		if new_scene == null:
			print("Error: Scene instantiation faled for " + scene_name)
			return
		
		scenes[scene_name] = new_scene
		scene_spawn_point.add_child(new_scene)
		print("Children of SceneLoadPoint after adding scene: ")
		for child in scene_spawn_point.get_children():
			print(child.name)
		print("Added new scene to SceneLoadPoint: " + new_scene.name)
	else:
		new_scene = scenes[scene_name]
		print("Using cached scene: " + new_scene.name)
		
	# Show the selected scene
	new_scene.visible = true
	print("Setting new scene visible: " + new_scene.name)
	
	# Update current_scene reference
	current_scene = new_scene
	print("Updated current_scene to: " + current_scene.name)
	
	print("Scene Spawn Point Children After: ", scene_spawn_point.get_child_count())

	# Load home scene if active monster quest exists
	if scene_name == "Home" and QuestManager.active_monster_quest != null:
		monster_spawn_point = current_scene.get_node("ExaminationTable/MonsterSpawnPoint")
		if QuestManager.active_monster_quest.has_method("home_scene_load"):
			QuestManager.active_monster_quest.home_scene_load.call_deferred()

func play_sound():
	var audio_stream = get_node("/root/Header/MainMusic")
	if audio_stream:
		# Assign sound to play here or in inspector
		audio_stream.stream = load("res://Sounds/ToolSuccessSound.wav")
		audio_stream.play()


	DialogueManager.start_convo("Wizard")
