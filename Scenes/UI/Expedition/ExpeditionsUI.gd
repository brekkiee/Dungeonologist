extends Control

var popup = null;
var rewardUI = null

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = get_node("PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1/Button")

# Called when the node enters the scene tree for the first time.
func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	popup = get_node("BagPopUp");
	popup.DungeonName = "NULL"
	popup.DungeonFloor = "Floor 0";
	popup.AdventurerName = "Colin"
	popup.update();
	popup.visible = false
	
	rewardUI = get_node("ExpeditionRewards")
	rewardUI.visible = false
	ExpeditionManager.expeditionUI = self
	pass
	

func show_rewards(rewards):
	rewardUI.visible = true
	rewardUI.expo_title = str(popup.DungeonName," " ,popup.DungeonFloor)
	rewardUI.expo_rewards = rewards

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called When expo button is pressed
func on_button_pressed_expo1():
	print("Expedition 1 Button Pressed");
	
	popup.DungeonName = "expo";
	popup.DungeonFloor = "1";
	popup.AdventurerName = "Colin"
	popup.update()
	popup.visible = true;
	pass

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
