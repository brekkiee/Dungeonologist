extends Control

var expo_title: String = ""
var expo_rewards: Array[RewardResource] = []

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = $BG/Button  # Adjust the node path if necessary

func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	button.connect("pressed", Callable(self, "_on_button_pressed"))
	self.visible = false  # Hide by default

func show_rewards():
	self.visible = true
	$BG/MC/VB/Title.text = expo_title  # Adjust the node path if necessary
	var content_text = ""
	for r in expo_rewards:
		if r.isItem:
			content_text += str(r.quantity) + "x " + r.item_data.Name + "\n"
		else:
			content_text += "1x " + r.monster_name.name + "\n"
	$BG/MC/VB/Content.text = content_text  # Adjust the node path if necessary

func _on_button_pressed():
	self.visible = false
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
