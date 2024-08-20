extends Control

@onready var npc_sprite = $CharacterSprite
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

var dialogues = {
	0: [],
	1: [],
	2: [],
}
var texture_mappings = {}
var current_dialogue_id = 0

func _ready():
	if not npc_sprite:
		print("Failed to find CharacterSprite node! Check the path.")
	else:
		print("npc_sprite successfully found: ", npc_sprite)
		update_npc_sprite_based_on_active_quest()

	_load_dialogue()
	DialogueManager.connect("chat_finished", Callable(self, "_on_chat_finished"))
	DialogueManager.connect("emotion_changed", Callable(self, "_on_emotion_changed"))

# Method to update the NPC sprite based on the active quest
func update_npc_sprite_based_on_active_quest():
	var active_quest = QuestManager.active_quests["chat"]
	
	if active_quest and active_quest is QuestBase:  # Ensure it’s of the correct type
		var sprite_path = active_quest.info.NpcSprite
		update_sprite(sprite_path)
	else:
		print("No active quest or active quest is not of type QuestBase.")

# Method to update the NPC sprite
func update_sprite(texture_path: String):
	print("Passed in NPC texture_path: ", texture_path)
	var texture = load(texture_path)
	if not texture:
		print("Failed to load texture from path: ", texture_path)
		return
	if not npc_sprite:
		print("npc_sprite is null! Ensure the reference is correct.")
		print("npc_sprite: ", npc_sprite)
		return
	print("Texture loaded successfully, attempting to set texture.")
	npc_sprite.texture = texture
	npc_sprite.queue_redraw()
	print("Sprite updated successfully to: ", texture_path)

# Load dialogue from the JSON file
func _load_dialogue():
	var file = FileAccess.open(dialogue_file, FileAccess.READ) 
	var content = JSON.parse_string(file.get_as_text())	

	for entry in content:
		if entry.has("texture"):
			texture_mappings[entry["emotion"]] = entry["texture"]
		elif entry.has("chat_num"):
			dialogues[int(entry["chat_num"])].append(entry)

# Handle button press to start or continue the chat
func _on_button_pressed():
	if not already_met:
		_start_chat(dialogues[0])
		already_met = true
	elif not quest_finished:
		_start_chat(dialogues[current_dialogue_id])
	else:
		# Repeat the final dialogue after the quest is complete
		repeat_final_dialogue()

# Start a chat session using the provided array
func _start_chat(dialogue_array: Array):
	print("Starting chat session...")
	DialogueManager.start_chat(texture_mappings, dialogue_array)
	DialogueManager.advance_text()
	
# Called when the chat finishes
func _on_chat_finished():
	if not quest_finished:
		current_dialogue_id += 1
		if current_dialogue_id == 2:
			quest_finished = true
			QuestManager.progress_quest("chat", 2)
		else:
			QuestManager.progress_quest("chat", current_dialogue_id)

# Repeat the final dialogue after quest completion
func repeat_final_dialogue():
	var final_dialogue_stage = dialogues[2] # Use the last dialogue
	DialogueManager.start_chat(texture_mappings, final_dialogue_stage)
	DialogueManager.advance_text()
	
# Method to handle the emotion change and update the sprite
func _on_emotion_changed(emotion: String):
	var texture_path = texture_mappings.get(emotion, "")
	if texture_path != "":
		update_sprite(texture_path)
	else:
		print("No texture found for emotion: ", emotion)
