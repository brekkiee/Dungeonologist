extends Node

@onready var chat_box_scene = preload("res://Quests/Dialogue/chatbox.tscn")
var chat_lines: Array = []
var current_line_index = 0
var chat_box: Control = null
var chat_box_pos: Vector2 = Vector2(350, 400)
var is_chat_active = false
var can_advance_line = false
var texture_mappings: Dictionary

signal chat_finished

# Start new chat at given position with provided lines
func start_chat(emotions: Dictionary, lines: Array):
	if is_chat_active:
		return # Exit if chat is already active
		
	current_line_index = 0
	chat_lines = lines
	texture_mappings = emotions
	_instantiate_chat_box()
	is_chat_active = true

# set up new chat box scene
func _instantiate_chat_box():
	chat_box = chat_box_scene.instantiate()
	var scene_spawn_point = get_node("/root/Header/UI")
	
	# Connect signal to handle when the chat box is ready for the next line
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
	print("chatbox finished")
	can_advance_line = true

func advance_text():
	if is_chat_active and can_advance_line:
		chat_box.queue_free()
		current_line_index += 1
		if current_line_index >= (chat_lines.size()):
			_end_chat() 
		else:
			_instantiate_chat_box()
	else:
		print("Cannot advance line. Chat active:", is_chat_active, "Can advance line:", can_advance_line)

# End the current chat session with NPC
func _end_chat():
	is_chat_active = false
	print("Chat no longer active")
	current_line_index = 0 # Resets the line index
	# Emit signal to let NPC.gd know the chat has finished
	emit_signal("chat_finished")
