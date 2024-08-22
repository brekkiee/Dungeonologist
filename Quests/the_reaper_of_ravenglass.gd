extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "TheReaperOfRavenglass"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "The Reaper of Ravenglass"
	info["QuestDescription"] = {
		1: "Talk to Elspeth",
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 1
	
	start_quest()
