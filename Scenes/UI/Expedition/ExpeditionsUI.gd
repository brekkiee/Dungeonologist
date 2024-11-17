extends Control

var popup = null
var rewardUI = null

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = $PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1/Button  # Adjust the node path if necessary

@onready var flyer_texture_normal = $PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1.texture
@onready var flyer_texture_highlighted = preload("res://Assets/Sprites/Expeditions/Expe_Page_Highlight.png")

@onready var flyer_texture_rect = $PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1

func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

	# Register this instance with ExpeditionManager
	ExpeditionManager.expeditionUI_instance = self

	popup = get_node("BagPopUp")  # Adjust the node path if necessary
	if popup == null:
		print("Error: 'BagPopUp' node not found")
	else:
		popup.DungeonName = "NULL"
		popup.DungeonFloor = "Floor 0"
		popup.AdventurerName = "Colin"
		popup.update()
		popup.visible = false

	rewardUI = get_node("ExpeditionRewards")  # Adjust the node path if necessary
	if rewardUI == null:
		print("Error: 'ExpeditionRewards' node not found")
	else:
		rewardUI.visible = false

func show_rewards(rewards):
	rewardUI.visible = true
	rewardUI.expo_title = str(popup.DungeonName, " ", popup.DungeonFloor)
	rewardUI.expo_rewards = rewards
	rewardUI.show_rewards()

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)
	flyer_texture_rect.texture = flyer_texture_highlighted

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
	flyer_texture_rect.texture = flyer_texture_normal

func on_button_pressed_expo1():
	print("Expedition 1 Button Pressed")

	if popup != null:
		popup.DungeonName = "expo"
		popup.DungeonFloor = "1"
		popup.AdventurerName = "Colin"
		popup.update()
		popup.visible = true
	else:
		print("Error: 'popup' is null.")
