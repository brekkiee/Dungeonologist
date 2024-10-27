extends CanvasLayer

@onready var pause_menu_screen = $PauseMenuScreen

func _on_resume_button_pressed():
	GameManager.toggle_pause()

func _on_main_menu_button_pressed():
	# Unpause and go back to the Start Menu
	GameManager.toggle_pause()
	GameManager.change_scene("StartMenu")

func _on_settings_button_pressed():
	var settings_menu_scene = preload("res://Scenes/UI/SettingsMenu.tscn")
	var settings_menu = settings_menu_scene.instantiate()
	add_child(settings_menu)
	pause_menu_screen.visible = false
	settings_menu.connect("menu_closed", Callable(self, "_on_settings_menu_closed"))

func _on_settings_menu_closed():
	pause_menu_screen.visible = true

func _on_exit_button_pressed():
	DayNightCycle._on_about_to_quit()
	# Quit the game
	get_tree().quit()
