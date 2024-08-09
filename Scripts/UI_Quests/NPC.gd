extends Control

@onready var sprite_texture = $CharacterSprite
@onready var chat_pos = $ChatBox

@export var character_name = ""
@export var character_sprite: Texture2D 

@export_file("*.json") var dialogue_file
@export var DialogueName: String = ""

@onready var nameText = $NinePatchRect/Name
@onready var bodyText = $NinePatchRect/Chat
@onready var NPCtexture = $NPCTexture

var already_met = false
var quest_finished = false

var dialogue1 = []
var dialogue2 = []
var dialogue3 = []
var texture_mappings = {}
var current_dialogue_id = 0

func _ready():
	sprite_texture.texture = character_sprite
	start()

func start():
	load_dialogue()
	current_dialogue_id = -1
	#next_script()

func load_dialogue(): # Load dialogue_file into 3 seperate arrays

	var file = FileAccess.open(dialogue_file, FileAccess.READ) 
	
	var content = JSON.parse_string(file.get_as_text())	

	for entry in content:
		if entry.has("texture"):
			texture_mappings[entry["emotion"]] = entry["texture"]
		elif entry.has("chat_num"):
			match entry["chat_num"]:
				"0":
					dialogue1.append(entry)
				"1":
					dialogue2.append(entry)
				"2":
					dialogue3.append(entry)
	return

func load_texture(path: String) -> Texture: #load texture from dialogue_file
	var texture = ResourceLoader.load(path)
	if texture:
		return texture
	else:
		print("Failed to load texture: ", path)
		return null

func _on_main_ui_quest_complete_npc():
	quest_finished = true


func _on_button_pressed(): #start the chat for the first time
	if not already_met:
		print("buttonpress input event")
		DialogueManager.start_chat(texture_mappings, dialogue1)
		DialogueManager.advanceText()
		already_met = true
		# QuestManager.addQuest("TutorialQuest")
	elif already_met and not quest_finished:
		DialogueManager.start_chat(texture_mappings, dialogue2)
		DialogueManager.advanceText	()
	elif quest_finished:
		DialogueManager.start_chat(texture_mappings, dialogue3)
		DialogueManager.advanceText()
