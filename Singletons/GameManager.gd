extends Node

var current_scene: Node = null
var scenes: Dictionary = {}

@onready var start_menu_scene = preload("res://Scenes/Windows/StartMenu.tscn")
@onready var expedition_scene = preload("res://Scenes/Windows/expeditions.tscn")
@onready var alchemy_lab_scene = preload("res://Scenes/Windows/alchemy_lab.tscn")
@onready var monster_enclosure_scene = preload("res://Scenes/Windows/monster_enclosure.tscn")
@onready var garden_scene = preload("res://Scenes/Windows/garden.tscn")
@onready var scene_spawn_point: Node2D = get_node("/root/Header/SceneLoadPoint")

@onready var npc: Control = get_node("/root/Header/UI/MainUI/MainScreen/ScreenBorders/ChatWindow/Character")
#@onready var sprite_texture: TextureRect = npc.get_node("CharacterSprite")

func _ready():
	start_game()

func start_game():
	change_scene("MonsterEnclosure")
	QuestManager.add_quest("TutorialQuest")
	
# Change sub scene based on input scene_name
func change_scene(scene_name: String):
	if current_scene == null or scene_name != current_scene.name:
		print("Changing to scene: " + scene_name)
		_goto_scene(scene_name)

func _goto_scene(scene_name: String):
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
	
func _instantiate_scene(scene_name: String) -> Node:
	match scene_name:
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

#	DialogueManager.start_convo("Wizard")
