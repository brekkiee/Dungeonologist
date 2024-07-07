extends Control

@onready var sprite_texture = $CharacterSprite
@onready var chat_pos = $ChatBoxPosition

@export var character_name = ""
@export var character_sprite: Texture2D 

var already_met = false
var quest_finished = false

#First meeting dialogue
var new_char_lines: Array[String] = [
	"It is I, Guntheidon.",
	"And you are this… \n“Dungeon-ologist”, yes? Yes.",
	"My dear friend Carlson has taken ill.\n You must help him.",
]

# hurry the player dialogue TODO: change variable names
var lines: Array[String] = [
	"Hurry!",
	"Shh… it’s okay Carlson, old boy. ",
]

# Quest completed dialogue
var quest_complete_lines: Array[String] = [
	"Carlson! You’re cured!",
	"The dungeon speaks highly of you, Dungeon-ologist. ",
	"We shall be comrades from this day forth.",
	"Good day to you. "
]
	
func _ready():
	sprite_texture.texture = character_sprite
	
func _unhandled_input(event):
	# check if advance text action is pressed (spacebar for now) check character met yet
	if event.is_action_pressed("advance_text") && not already_met:
		DialogueManager.start_chat(chat_pos.global_position, new_char_lines)
		already_met = true
		#QuestManager.addQuest("TutorialQuest")
		
		# check advance text, but quest not complete
	elif event.is_action_pressed("advance_text") && already_met && not quest_finished:
		DialogueManager.start_chat(chat_pos.global_position, lines)
		
		# check if advance text, quest IS finished
	elif event.is_action_pressed("advance_text") && quest_finished:
		DialogueManager.start_chat(chat_pos.global_position, quest_complete_lines)


func _on_main_ui_quest_complete_npc():
	quest_finished = true
