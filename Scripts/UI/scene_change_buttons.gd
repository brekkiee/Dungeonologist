extends Control

@export var normal_button_style: StyleBoxTexture
@export var active_button_style: StyleBoxTexture

@onready var enclosure_button: Button = $MonsterEnclosureButton
@onready var garden_button: Button = $GardenButton
@onready var alchemy_button: Button = $AlchemyLabButton
@onready var expeditions_button: Button = $ExpeditionsButton

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")

func _ready():
	$MonsterEnclosureButton.set_pressed_no_signal(true)

	# Connect mouse entered and exited signals for all buttons
	enclosure_button.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(enclosure_button))
	enclosure_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	garden_button.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(garden_button))
	garden_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	alchemy_button.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(alchemy_button))
	alchemy_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	expeditions_button.connect("mouse_entered", Callable(self, "_on_mouse_entered").bind(expeditions_button))
	expeditions_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered(button):
	print("button passed in: ", button)
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)

func _on_expeditions_button_pressed():
	GameManager.change_scene("Expeditions")
	Input.set_custom_mouse_cursor(null)

func _on_alchemy_lab_button_pressed():
	GameManager.change_scene("AlchemyLab")
	Input.set_custom_mouse_cursor(null)

func _on_monster_enclosure_button_pressed():
	GameManager.change_scene("MonsterEnclosure")
	Input.set_custom_mouse_cursor(null)

func _on_garden_button_pressed():
	GameManager.change_scene("Garden")
	Input.set_custom_mouse_cursor(null)
