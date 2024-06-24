extends Control

@onready var sprite_texture = $CharacterSprite
@onready var chat_pos = $ChatBoxPosition

@export var character_name = ""
@export var character_sprite: Texture2D 

var already_met = false
var quest_finished = false

var new_char_lines: Array[String] = [
	"It is I, Guntheidon.",
	"And you are this… \n“Dungeon-ologist”, yes? Yes.",
	"My dear friend Carlson has taken ill.\n You must help him.",
]

var lines: Array[String] = [
	"Hurry!",
	"Shh… it’s okay Carlson, old boy. ",
]

var quest_complete_lines: Array[String] = [
	"Carlson! You’re cured!",
	"The dungeon speaks highly of you, Dungeon-ologist. ",
	"We shall be comrades from this day forth.",
	"Good day to you. "
]
	
func _ready():
	sprite_texture.texture = character_sprite
	
func _unhandled_input(event):
	if event.is_action_pressed("advance_text") && not already_met:
		DialogueManager.start_chat(chat_pos.global_position, new_char_lines)
		already_met = true
		QuestManager.addQuest("TutorialQuest")
		
	elif event.is_action_pressed("advance_text") && already_met && not quest_finished:
		DialogueManager.start_chat(chat_pos.global_position, lines)
		
	elif event.is_action_pressed("advance_text") && quest_finished:
		DialogueManager.start_chat(chat_pos.global_position, quest_complete_lines)
		QuestManager.completeQuest("TutorialQuest")
		

func _on_main_ui_quest_complete_npc():
	quest_finished = true
