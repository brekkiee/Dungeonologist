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
var dialogues = {
	0: [],
}
var texture_mappings = {}

func _ready():
	if not npc_sprite:
		print("Failed to find CharacterSprite node! Check the path.")
	else:
		#print("npc_sprite successfully found: ", npc_sprite)
		update_npc_sprite_based_on_active_quest()

	_load_dialogue()
	DialogueManager.connect("chat_finished", Callable(self, "_on_chat_finished"))
	DialogueManager.connect("emotion_changed", Callable(self, "_on_emotion_changed"))

# Method to update the NPC sprite based on the active quest
func update_npc_sprite_based_on_active_quest():
	var active_quest = QuestManager.active_quest
	
	if active_quest and active_quest is QuestBase:  # Ensure it’s of the correct type
		var sprite_path = active_quest.info.NpcSprite
		update_sprite(sprite_path)
	else:
		print("No active quest or active quest is not of type QuestBase.")

# Method to update the NPC sprite
func update_sprite(texture_path: String):
	#print("Passed in NPC texture_path: ", texture_path)
	var texture = load(texture_path)
	if not texture:
		print("Failed to load texture from path: ", texture_path)
		return
	if not npc_sprite:
		print("npc_sprite is null! Ensure the reference is correct.")
		print("npc_sprite: ", npc_sprite)
		return
	#print("Texture loaded successfully, attempting to set texture.")
	npc_sprite.texture = texture
	npc_sprite.queue_redraw()
	#print("Sprite updated successfully to: ", texture_path)

# Load dialogue from the JSON file
func _load_dialogue():
	clear_dialogue()
	var file = FileAccess.open(dialogue_file, FileAccess.READ) 
	var content = JSON.parse_string(file.get_as_text())	

	for entry in content:
		if entry.has("texture"):
			texture_mappings[entry["emotion"]] = entry["texture"]
		elif entry.has("chat_num"):
			var chat_num = int(entry["chat_num"])
			if not dialogues.has(chat_num):
				dialogues[chat_num] = []
			dialogues[chat_num].append(entry)
	#print("Dialogue loaded from file:", dialogue_file)
# Handle button press to start or continue the chat
func _on_button_pressed():
	if DialogueManager.is_chat_active:
		DialogueManager.advance_text()
	elif DialogueManager.chat_ended:
		DialogueManager.close_chat_box()
	else:
		_start_chat(dialogues[0])

# Start a chat session using the provided array
func _start_chat(dialogue_array: Array):
	#print("Starting chat session...")
	DialogueManager.start_chat(texture_mappings, dialogue_array)
#	DialogueManager.advance_text()
	
# Called when the chat finishes
func _on_chat_finished():
	# When chat finished, player can click again to replay chat or progress quest
	QuestManager.on_NPC_chat()
	#print("Chat finished.")
	
# Method to handle the emotion change and update the sprite
func _on_emotion_changed(emotion: String):
	var texture_path = texture_mappings.get(emotion, "")
	if texture_path != "":
		update_sprite(texture_path)
	else:
		print("No texture found for emotion: ", emotion)

func clear_dialogue():
	dialogues = {
		0: [],
	}
	DialogueManager.close_chat_box()
	#print("Dialogue cleared and chat box closed")
