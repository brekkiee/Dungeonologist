extends Node

# Quest information
var info: Dictionary = {
	"Name": "HarvestTutorial",             # Name of the quest
	"NpcSprite" : "res://Assets/Sprites/Characters/char_5_Kael.png",       # Path to the NPC sprite

	"QuestDisplayName": "Harvest a plant", # Display name of the quest
	"QuestDescription": {   # Descriptions for each stage of the quest
		1: "Click on a plant to harvest",
		2: "Click on another plant to harvest"
	}
}

# Dialogue for the quest
#var dialogue: Dictionary = {
#	"StartDialogue" : [
#		"", "", "",    # Dialogue lines for the start of the quest
#	],
#	"CompleteDialogue": [
#		"", "", "",    # Dialogue lines for quest completion
#	],
#}

var CurrentStage = 0   # Current stage of the quest
var first_time_opening_home_scene = true   # Check if home scene is opened for the first time

func _init():
	pass   # Initialization function

# Load the home scene for the first time
func home_scene_load():
	if first_time_opening_home_scene:
		pass

# Update the quest display based on the current stage
func update_quest_display():
	if CurrentStage == 0:
		pass
	elif CurrentStage == 1:
		pass

# Handle chat finished event
func chat_finished():
	if CurrentStage == 2:
		pass

# Instructions for replication:
# 1. Set the values in the 'info' dictionary with specific details of the quest.
# 2. Populate the 'dialogue' dictionary with relevant dialogue lines.
# 3. Implement logic in 'home_scene_load', 'update_quest_display', and 'chat_finished' as required for the quest progression.
