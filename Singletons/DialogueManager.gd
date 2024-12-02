extends Node

@onready var chat_box_scene = preload("res://Quests/Dialogue/chatbox.tscn")
var chat_lines: Array = []
var current_line_index = 0
var chat_box: Control = null
var chat_box_pos: Vector2 = Vector2(350, 400)
var is_chat_active = false
var can_advance_line = false
var chat_ended = false
var texture_mappings: Dictionary

signal chat_finished

func _ready():
	set_process_input(true)  # Ensure this node processes input events

# Start new chat at given position with provided lines
func start_chat(emotions: Dictionary, lines: Array):
	if is_chat_active:
		return  # Exit if chat is already active

	# Remove existing chat box
	if chat_box and chat_box.is_inside_tree():
		chat_box.queue_free()

	current_line_index = 0
	chat_lines = lines
	texture_mappings = emotions
	_instantiate_chat_box()
	is_chat_active = true
	chat_ended = false

# Set up new chat box scene
func _instantiate_chat_box():
	chat_box = chat_box_scene.instantiate()
	var scene_spawn_point = get_node("/root/Header/UI")

	# Connect signal to handle when the chat box is ready for the next line
	if not chat_box.finished.is_connected(_on_chat_box_finished):
		chat_box.finished.connect(_on_chat_box_finished)

	# Add chat box to the UI and set its position
	scene_spawn_point.add_child(chat_box)
	chat_box.global_position = chat_box_pos

	_display_current_line()

# Display the current line of dialogue in the chat box	
func _display_current_line():
	var current_line = chat_lines[current_line_index]
	var speaker_name = current_line.get("name", "")
	var dialogue_text = current_line.get("text", "")
	var emotion = current_line.get("emotion", "")

	var texture_path = texture_mappings.get(emotion, "")

	chat_box.display_text(speaker_name, dialogue_text, texture_path)

	can_advance_line = false

# Enable advancing to next line when chat box finishes current line
func _on_chat_box_finished():
	# Defer setting can_advance_line to the next frame
	call_deferred("_set_can_advance_line")

func _set_can_advance_line():
	can_advance_line = true

func advance_text():
	if is_chat_active:
		if can_advance_line:
			current_line_index += 1
			print(current_line_index)
			if current_line_index >= chat_lines.size()-1:
				_display_current_line()
				_end_chat()
			else:
				_display_current_line()
		else:
			chat_box.finish_text()
			# Return immediately to prevent advancing to the next line in the same input
			return
	else:
		print("Cannot advance line. Chat active:", is_chat_active)

# End the current chat session with NPC
func _end_chat():
	is_chat_active = false
	current_line_index = 0  # Resets the line index
	chat_ended = true
	

# Method to close the chat box if the player clicks the NPC after the chat ends
func close_chat_box():
	if chat_box:
		chat_box.queue_free()
		chat_box = null
		chat_ended = false
		is_chat_active = false
		emit_signal("chat_finished")

# Input handling for finishing the text quickly and advancing lines
func _input(event):
	if is_chat_active:
		# Handle only mouse button events
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				# Left mouse button pressed
				advance_text()
	elif chat_ended:
		# If the chat has ended and the player clicks, close the chat box
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				close_chat_box()
