@tool
extends Node2D

# references
var scene_path: String = "res://Scenes/item.tscn"
@onready var item_sprite = $Sprite2D

# item properties
@export var item_texture = Texture
@export var item_name = ""
@export var item_type = ""
@export var item_effect = ""

var item_hovered = false
var item_is_draggable = false

func _ready():
	# assign texture when game runs
	if not Engine.is_editor_hint():
		item_sprite.texture = item_texture

func _process(delta):
	# assign texture while still in the editor
	if Engine.is_editor_hint():
		item_sprite.texture = item_texture
		
	if item_is_draggable:
		global_position = get_global_mouse_position() # make item follow mouse
		
		if Input.is_action_just_pressed("pick_up"): # drop item at current position
			global_position = get_global_mouse_position()
			item_is_draggable = false
		
	elif item_hovered && Input.is_action_just_pressed("pick_up"):
		pickup_item()
		

# add item to inventory
func pickup_item():
	var item = {
		"quantity" : 1,
		"texture" : item_texture,
		"name" : item_name,
		"type" : item_type,
		"effect" : item_effect,
		"scene_path" : scene_path,
	}
	print("Pick up " + item_name)
	InventoryManager.addItem(item)
	self.queue_free() # remove from scene

# picks up item when clicked on with the mouse
func _on_mouse_entered():
	item_hovered = true
	print(item_name + " is hovered")

func _on_mouse_exited():
	item_hovered = false
	print(item_name + " is not hovered")

func set_item_data(data):
	item_texture = data["texture"]
	item_name = data["name"]
	item_type = data["type"]
	item_effect = data["effect"]
