extends Control

@onready var sprite_texture = $CharacterSprite
@onready var chat_pos = $ChatBoxPosition

@export var character_name = ""

# Variable for storing current dialogue (old method)
var current_dialogue = []

# Old method for starting a conversation (can be re-enabled)
func _unhandled_input(event):
	# Check if advance text action is pressed (spacebar)
	if event.is_action_pressed("advance_text"):
		#DialogueManager.start_chat(chat_pos.global_position, current_dialogue)
		pass

# Start dialogue with the first line appearing on screen
func start_dialogue(dialogue):
	DialogueManager.start_chat(chat_pos.global_position, dialogue)
