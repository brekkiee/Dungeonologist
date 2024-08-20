extends Control

@onready var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")

func _ready():
	# Connect the "pressed" signal of the start button to a custom function
	$StartMenuScreen/ButtonGridContainer/StartButton.connect("pressed", Callable(self, "_on_start_button_pressed"))
	
	# Connect a exit button
	if $StartMenuScreen/ButtonGridContainer/ExitButton:
		$StartMenuScreen/ButtonGridContainer/ExitButton.connect("pressed", Callable(self, "_on_exit_button_pressed"))
	
func _on_start_button_pressed():
	GameManager.start_game()

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
