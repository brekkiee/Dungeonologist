extends Control

@export var normal_button_style: StyleBoxTexture
@export var active_button_style: StyleBoxTexture

func _ready():
	$MonsterEnclosureButton.set_pressed_no_signal(true)
	
func _on_expeditions_button_pressed():
	GameManager.change_scene("Expeditions")

func _on_alchemy_lab_button_pressed():
	GameManager.change_scene("AlchemyLab")

func _on_monster_enclosure_button_pressed():
	GameManager.change_scene("MonsterEnclosure")

func _on_garden_button_pressed():
	GameManager.change_scene("Garden")
