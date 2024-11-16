extends Control

var expo_title: String
var expo_rewards: Array[RewardResource]

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = get_node("BG/Button")

func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("BG/MC/VB/Title").text = expo_title
	get_node("BG/MC/VB/Content").text = ""
	for r in expo_rewards:
		if r.isItem:
			get_node("BG/MC/VB/Content").text = str(get_node("BG/MC/VB/Content").text, r.quantity ,"x ",r.item_data.Name, "\n")
		else:
			get_node("BG/MC/VB/Content").text = str(get_node("BG/MC/VB/Content").text, "1x ",r.monster_name.name, "\n")

func show_rewards():
	self.visible = true

func _on_button_pressed():
	self.visible = false
	pass # Replace with function body.
	
func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
