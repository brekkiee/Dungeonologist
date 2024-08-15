extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "TutorialQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Talk to Elspeth"
	info["QuestDescription"] = {
		2: "Quest completed! You talked to Elspeth.",
		1: "Click on Elspeth to chat"
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 2
	
	start_quest()
