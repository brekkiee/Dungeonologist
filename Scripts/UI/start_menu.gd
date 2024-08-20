extends Control

@onready var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")

func _ready():
	# Connect the "pressed" signal of the start button to a custom function
	$StartMenuScreen/ButtonGridContainer/StartButton.connect("pressed", Callable(self, "_on_start_button_pressed"))
	
	# Connect a exit button
	if $StartMenuScreen/ButtonGridContainer/ExitButton:
		$StartMenuScreen/ButtonGridContainer/ExitButton.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	
func _on_start_button_pressed():
		# Instantiate and add MainWindow to the scene tree
	var main_window = main_window_scene.instantiate()
	get_tree().root.add_child(main_window)
	
	GameManager.change_scene("MonsterEnclosure")

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
