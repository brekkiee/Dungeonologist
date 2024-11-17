extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "CompletedTutorialQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Tutorial Completed"
	info["QuestDescription"] = {
		1: "Thank you for playing!",
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 2
	
	start_quest()
