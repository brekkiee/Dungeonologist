extends Node2D

# references
var scene_path: String = "res://Scenes/monster_enclosure.tscn"
@onready var enclosure_bg = $UI/Control/TextureRect

# enclosure properties
@export var enclosure_texture = Texture
@export var enclosure_name = ""
@export var enclosure_habitat = []

@export var enclosure_monsters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#MonsterManager.enclosuresUpdated.connect(_on_enclosures_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_new_enclosure():
	var enclosure = {
		"texture" : enclosure_texture,
		"name" : enclosure_name,
		"habitat" : enclosure_habitat,
		"scene_path" : scene_path,
	}
	print("Adding " + enclosure_name)

func set_enclosure_data(data):
	enclosure_texture = data["texture"]
	enclosure_name = data["name"]
	enclosure_habitat = data["habitat"]
