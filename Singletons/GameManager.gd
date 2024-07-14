extends Node

var current_scene = null

@onready var home_scene = preload("res://Scenes/Windows/home.tscn")
@onready var alchemy_lab_scene = preload("res://Scenes/Windows/alchemy_lab.tscn")
@onready var monster_enclosure_scene = preload("res://Scenes/Windows/monster_enclosure.tscn")
@onready var garden_scene = preload("res://Scenes/Windows/garden.tscn")

@onready var npc: Control = get_node("/root/Header/UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character/")
var spawned_monster: Node2D = null

func _ready():
	start_game()

func start_game():
	QuestManager.addQuest("TutorialQuest")
	call_deferred("_deferred_goto_scene", home_scene)

# Change sub scene based on input scene_name
func change_scene(scene_name):
	print(scene_name)
	if scene_name != current_scene.name:
		if scene_name == "Home":
			call_deferred("_deferred_goto_scene", home_scene)
		elif scene_name == "AlchemyLab":
			call_deferred("_deferred_goto_scene", alchemy_lab_scene)
		elif scene_name == "MonsterEnclosure":
			call_deferred("_deferred_goto_scene", monster_enclosure_scene)
		elif scene_name == "Garden":
			call_deferred("_deferred_goto_scene", garden_scene)

func _deferred_goto_scene(scene):
	var scene_spawn_point = get_node("/root/Header/SceneLoadPoint")
	if not scene_spawn_point:
		print("Can't load home scene")
		return

	print("Changing Scene")
	# Safely remove current scene
	if current_scene != null:
		current_scene.free()
	# Instance new scene
	current_scene = scene.instantiate()
	# Add new scene to active scene
	scene_spawn_point.add_child(current_scene)

	# Load home scene if active monster quest exists
	if (scene == home_scene and QuestManager.active_monster_quest != null):
		if QuestManager.active_monster_quest.has_method("home_scene_load"):
			QuestManager.active_monster_quest.home_scene_load.call_deferred()

func play_sound():
	var audio_stream = get_node("/root/Header/MainMusic")
	if audio_stream:
		# Assign sound to play here or in inspector
		audio_stream.stream = load("res://Sounds/ToolSuccessSound.wav")
		audio_stream.play()
