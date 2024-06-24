extends Node

@onready var quest_display_scene = preload("res://Scenes/quest_display.tscn")

var quest_display

var Quests: Dictionary = {
	"TutorialQuest" :{
		"QuestName": "Help Carlson",
		"CurrentStage": 0,
		"QuestDescription":{
			"1": "Diagnose Carlson",
			"2": "Treat Carlson"
		}
	},
}

var ActiveQuests: Dictionary = {}
var CompletedQuests: Array = []

func _ready():
	quest_display = quest_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(quest_display)

# add quest to active quests
func addQuest(quest_id: String):
	if quest_id in Quests.keys():
		ActiveQuests[quest_id] = Quests[quest_id]
		advanceQuest(quest_id)
	else:
		print(quest_id + ": quest not found.")

# update current stage of quest
func advanceQuest(quest_id: String):
	# increment current stage by 1 and convert to string
	ActiveQuests[quest_id]["CurrentStage"] += 1
	var current_stage: String = str(ActiveQuests[quest_id]["CurrentStage"])
	
	if current_stage in ActiveQuests[quest_id]["QuestDescription"].keys():
		# get updated quest description for the new stage
		quest_display.update_quest(ActiveQuests[quest_id]["QuestName"], ActiveQuests[quest_id]["QuestDescription"][current_stage])
	else:
		completeQuest(quest_id)
	
# handle quest completion
func completeQuest(quest_id: String):
	CompletedQuests.append(Quests[quest_id]["QuestName"])
	ActiveQuests.erase(quest_id)
	quest_display.complete_quest()
	print("quest completed")
