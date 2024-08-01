extends Node

# Stores info required for the quest
var info: Dictionary = {
	"Name": "TutorialQuest",  # Name of the quest
	"MonsterSpawn": "res://Quests/TutorialQuest/tutorialslime.tscn",  # Path to the monster scene
	"NpcSprite" : "res://Assets/Sprites/char_1_Guntheidon.png",  # Path to the NPC sprite

	"QuestDisplayName": "Help Carlson",  # Display name of the quest
	"QuestDescription": {  # Descriptions for each stage of the quest
		1: "Diagnose Carlson",
		2: "Treat Carlson"
	}
}

# Stores the dialogue the NPC will speak
var dialogue: Dictionary = {
	"StartDialogue" : [
		"It is I, Guntheidon.",
		"And you are this… \n“Dungeon-ologist”, yes? Yes.",
		"My dear friend Carlson has taken ill.\n You must help him."
	],
	"IntermediateDialogue": [
		"Hurry!",
		"Shh… it’s okay Carlson, old boy. "
	],
	"CompleteDialogue": [
		"Carlson! You’re cured!",
		"The dungeon speaks highly of you, Dungeon-ologist. ",
		"We shall be comrades from this day forth.",
		"Good day to you. "
	],
}

var CurrentStage = 0  
# Check if this was the first time the home screen is opened when the quest is active
var first_time_opening_home_scene = true

# Initialization function for this script
func _init():
	print("Started tutorial quest script")

# Function called from the GameManager when the home scene is loaded
func home_scene_load():
	if first_time_opening_home_scene:
		GameManager.npc.start_dialogue(dialogue["StartDialogue"])
		first_time_opening_home_scene = false
	update_quest_display()
	print("Quest_load_home_scene")
	# Load the wizard sprite into the NPC node
	GameManager.npc.sprite_texture.texture = load(info.NpcSprite)
	var monster_scene = load(info.MonsterSpawn)

	var monster = monster_scene.instantiate()
	GameManager.monster_spawn_point.add_child(monster)
	GameManager.spawned_monster = monster

# Update the quest display
func update_quest_display():
	if CurrentStage == 0:
		QuestManager.quest_display.update_quest(
			info.QuestDisplayName, info.QuestDescription[1])
	elif CurrentStage == 1:
		QuestManager.quest_display.update_quest(
			info.QuestDisplayName, info.QuestDescription[2])
	else:
		QuestManager.quest_display.complete_quest()

# Function called from the tutorialslime when it detects a click from a tool
func tool_used(tool_name):
	print("tool " + tool_name)
	GameManager.play_sound()
	if tool_name == "MagnifyingGlass" and CurrentStage == 0:
		GameManager.npc.start_dialogue(dialogue["IntermediateDialogue"])
		CurrentStage = 1

	elif tool_name == "Tweezers" and CurrentStage == 1:
		CurrentStage = 2
		GameManager.spawned_monster.update_monster()
		GameManager.npc.start_dialogue(dialogue["CompleteDialogue"])
	update_quest_display()

# Function that is called when a chat is completed
func chat_finished():
	if CurrentStage >= 2:
		print("chat finished, tutorial quest completed")
		#QuestManager.delete_monster_quest()

# Function gets executed when the quest is deleted, currently not needed but can be used if required
#func _notification(what):
#	if (what == NOTIFICATION_PREDELETE):
#		QuestManager.quest_display.complete_quest()
#		info.MonsterSpawns[0].queue_free()
