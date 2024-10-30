extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "GuntheidonQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_1_Guntheidon.png"
	info["QuestDisplayName"] = "Progress Quest"
	info["QuestDescription"] = {
		1: "Talk to Guntheidon",
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 2
	
	start_quest()
