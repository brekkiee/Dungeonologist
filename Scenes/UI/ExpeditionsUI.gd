extends Control

var current_expo_level = 0

var adventurers = {
	"Colin": preload("res://Assets/Sprites/Characters/char_3_Colin.png")
}
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PC/ExpoPopUp").visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_button_pressed_expo1():
	current_expo_level = 1
	get_node("PC/ExpoPopUp/TR1/MC1/HB1/Adventurer/AdventurerPortrait").texture = adventurers.Colin
	get_node("PC/ExpoPopUp").visible = true
