extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "SettlingIn"
	info["Type"] = "1"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Settling In"
	info["QuestDescription"] = {
		1: "Harvest a plant from the garden.",
		2: "Feed a monster",
		3: "Chat with Elspeth",
	}
#	info["QuestProgression"] = {
#		1: "HarvestPlant",
#		2: "FeedMonster",
#		3: "ChatNPC",
#	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 3
	
	start_quest()
