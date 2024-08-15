extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "TutorialQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Talk to Elspeth"
	info["QuestDescription"] = {
		1: "Click on Elspeth to chat",
		2: "Click on Elspeth again to continue chat.",
		3: "Quest completed."
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 3
	
	start_quest()
