extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "SettlingIn"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Settling In"
	info["QuestDescription"] = {
		1: "Chat with Elspeth",
		2: "Harvest a plant from the garden.",
		3: "Feed a monster",
		4: "Talk to Elspeth"
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 4
	
	start_quest()
