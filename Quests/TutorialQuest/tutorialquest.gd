extends QuestBase

# Stores info required for the quest
var info: Dictionary = {
	"Name": "TutorialQuest",
	"Type": "chat",
	"NpcSprite": "res://Assets/Sprites/Characters/char_1_Guntheidon.png",
	"QuestDisplayName": "Talk to Guntheidon",
	"QuestDescription": {
		1: "Click on Guntheidon to chat",
		2: "Quest completed! You talked to Guntheidon."
	}
}

func _ready():
	quest_name = info.Name
	quest_type = "chat"
	max_stage = 2 # 2 quest stages: 1. Chat instruction, 2: Quest completion
	start_quest()

# Override the method from QuestBase to start the quest
func start_quest():
	print("Starting tutorial quest...")
	update_quest_display()
	update_npc_sprite(info.NpcSprite)

# Override the method from QuestBase to progress the quest
func progress_quest(stage: int):
	if stage <= max_stage:
		current_stage = stage
		update_quest_display()
		if current_stage == max_stage:
			complete_quest()

# Override the method from BaseQuest to update the quest display
func update_quest_display():
	var display_text = ""
	if current_stage < max_stage:
		display_text = info.QuestDescription[current_stage + 1]
	else:
		display_text = info.QuestDescription[max_stage]

	QuestManager.quest_display.update_quest(info.QuestDisplayName, display_text)
	print("quest script params Name: ", info.QuestDisplayName)
	print("quest script params Description: ", display_text)

# Override the method from BaseQuest to complete the quest
func complete_quest():
	print("Tutorial quest completed!")
	update_quest_display()
	# Handle any additional logic needed when the quest is completed
	QuestManager.complete_quest(quest_type)
