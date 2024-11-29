extends Control

var expo_title: String = ""
var expo_rewards: Array[RewardResource] = []

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = $BG/Button  # Adjust the node path if necessary

var monsters = {
	"common_shrooman": preload("res://Assets/Sprites/Monsters/CommonShrooman_Happy.png"),
	"common_slime": preload("res://Assets/Sprites/Monsters/CommonSlime_Happy.png"),
	"forest_dinglebat": preload("res://Assets/Sprites/Monsters/ForestDinglebat_Happy.png"),
	"nekomata": preload("res://Assets/Sprites/Monsters/Nekomata_Happy.png"),
	"plains_imp": preload("res://Assets/Sprites/Monsters/PlainsImp_Happy.png"),
	"shallows_jelly": preload("res://Assets/Sprites/Monsters/ShallowsJelly_Happy.png"),

}


func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	self.visible = false  # Hide by default

func show_rewards():
	self.visible = true
	$BG/MC/VB/Title.text = expo_title  # Adjust the node path if necessary
	for r in expo_rewards:
		if r.isItem:
			var _inv_item = preload("res://Scenes/UI/Inventory/InventoryItem.tscn").instantiate()
			_inv_item.ItemName = r.item_data.Name
			_inv_item.ItemQuantity = r.quantity
			_inv_item.data = r.item_data
			_inv_item.get_node("TextureRect/Label").text = str(r.quantity)
			_inv_item.get_node("TextureRect").texture = r.item_data.Sprite
			$BG/MC/VB/Content/GridContainer.call_deferred("add_child", _inv_item)
			

func _on_button_pressed():
	self.visible = false
	
	for r in expo_rewards:
		for i in range(r.quantity):
			match r.item_data.Type:
				6:
					InventoryManager.add_potion_inventory_item(r.item_data)
				_:
					InventoryManager.add_plant_inventory_item(r.item_data)	
	# Optionally queue_free() if you want to remove it from the scene tree
	# queue_free()

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)

func set_expo_title(title: String):
	expo_title = title

func set_expo_rewards(rewards: Array[RewardResource]):
	expo_rewards = rewards
