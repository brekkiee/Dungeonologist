extends Control

@export var PotionTexture: TextureRect
@export var DungeonName: String
@export var DungeonFloor: String
@export var AdventurerName: String

var current_potion

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = get_node("BG/Info/HBoxContainer/VBoxContainer/TextureRect/Button")

var adventurers = {
	"Colin": preload("res://Assets/Sprites/Characters/char_3_Colin.png")
}

var expo = null

func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# Update the Data shown onscreen
func update(expoData: Expeditions):
	expo = expoData
	get_node("BG/Sign/DungeonFloor").text = str("Floor ",DungeonFloor);
	get_node("BG/Sign/DungeonTitle").text = DungeonName;
	get_node("BG/Info/HBoxContainer/VBoxContainer/AP/TextureRect").texture = adventurers[AdventurerName];

# Called when there is a gui input event
func _on_potion_slot_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_potion == null:
				if InventoryManager.item_mouse_follow != null:
					print("Potion Slot Interacted With")
					current_potion = InventoryManager.item_mouse_follow
					
					if InventoryManager.current_potion_inventory.has(current_potion):
						get_node("BG/Info/HBoxContainer/Bag/PotionSlot/Potion").texture = current_potion.get_node("TextureRect").texture
						InventoryManager.item_used_click()
			else:
				if InventoryManager.item_mouse_follow != null:
					InventoryManager.add_potion_inventory_item(current_potion.ItemName)
					
					current_potion = InventoryManager.item_mouse_follow
					if InventoryManager.current_potion_inventory.has(current_potion):
						get_node("BG/Info/HBoxContainer/Bag/PotionSlot/Potion").texture = current_potion.get_node("TextureRect").texture
						InventoryManager.item_used_click()
					

# When Button is pressed
func _on_button_pressed():
	get_node("BG/Info/HBoxContainer/Bag/PotionSlot/Potion").texture = null
	current_potion = null
	self.visible = false
	ExpeditionManager.start_expedition(expo, AdventurerName, current_potion)
