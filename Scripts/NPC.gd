extends Control

@onready var sprite_texture = $CharacterSprite
@onready var chat_pos = $ChatBoxPosition

@export var character_name = ""
@export var character_sprite: Texture2D 

var already_met = false

var new_char_lines: Array[String] = [
	"Hi there.",
	"I'm a wizard!",
]

var lines: Array[String] = [
	"Poo poo~",
	"Pee pee!",
]

func _ready():
	sprite_texture.texture = character_sprite
	
func _unhandled_input(event):
	if event.is_action_pressed("advance_text") && not already_met:
		DialogueManager.start_chat(chat_pos.global_position, new_char_lines)
		already_met = true
	elif event.is_action_pressed("advance_text") && already_met:
		DialogueManager.start_chat(chat_pos.global_position, lines)
