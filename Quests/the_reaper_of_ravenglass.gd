extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "ReaperOfRavenglass"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "The Reaper of Ravenglass"
	info["QuestDescription"] = {
		1: "Talk to Colin",
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 1
	
	start_quest()
