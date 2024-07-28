@tool
extends Node2D

# references
var scene_path: String = "res://Scenes/monster.tscn"
@onready var monster_sprite = $Sprite2D

# monster properties
@export var monster_texture: Array[Texture2D] = []
@export var monster_name = ""
@export var monster_diet: Array[String] = []
@export var monster_habitat: Array[String] = []

var monster_hovered = false

func _ready():
	# assign texture when game runs
	if not Engine.is_editor_hint():
		monster_sprite.texture = monster_texture[0]

func _process(delta):
	# assign texture while still in the editor
	if Engine.is_editor_hint():
		monster_sprite.texture = monster_texture[0]

func add_new_monster():
	var monster = {
		"texture" : monster_texture,
		"name" : monster_name,
		"diet" : monster_diet,
		"habitat" : monster_habitat,
		"scene_path" : scene_path,
	}
	print("Adding " + monster_name)

func set_monster_data(data):
	monster_texture = data["texture"]
	monster_name = data["name"]
	monster_diet = data["diet"]
	monster_habitat = data["habitat"]
