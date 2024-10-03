extends Control

@onready var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")
@onready var start_menu_screen = $StartMenuScreen
	
func _on_start_button_pressed():
	GameManager.start_game()
	hide()

func _on_settings_button_pressed():
	var settings_menu_scene = preload("res://Scenes/UI/SettingsMenu.tscn")
	var settings_menu = settings_menu_scene.instantiate()
	add_child(settings_menu)
	start_menu_screen.visible = false
	settings_menu.connect("menu_closed", Callable(self, "_on_settings_menu_closed"))

func _on_settings_menu_closed():
	start_menu_screen.visible = true

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
