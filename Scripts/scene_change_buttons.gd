extends Control

@export var normal_button_style: StyleBoxTexture
@export var active_button_style: StyleBoxTexture

func change_active_button(button):
	button.add_theme_stylebox_override("normal", active_button_style)
	button.add_theme_stylebox_override("hover", active_button_style)

func _ready():
	# set active style based on current scene
	var scene_name = GameManager.current_scene.name
	if scene_name == "Home":
		change_active_button($HomeButton)
	elif scene_name == "AlchemyLab":
		change_active_button($AlchemyLabButton)
	elif scene_name == "MonsterEnclosure":
		change_active_button($MonsterEnclosureButton)

func _on_home_button_pressed():
	GameManager.change_scene("Home")

func _on_alchemy_lab_button_pressed():
	GameManager.change_scene("AlchemyLab")

func _on_monster_enclosure_button_pressed():
	GameManager.change_scene("MonsterEnclosure")

