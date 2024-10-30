extends Node

@onready var quest_display_scene = preload("res://Quests/quest_display.tscn")

var quest_display: Control
var active_quest = null  # Only one active quest
var completed_quests = []
var current_stage = 0

# Dictionary to store all quests for the game
var quests_data: Dictionary = {
	"SettlingIn" :{
		"script": "res://Quests/TutorialQuest/settling_in.gd",
		"stage1": "ChatNPC",
		"stage2": "HarvestPlant",
		"stage3": "FeedMonster",
	},
	"TheReaperOfRavenglass" :{
		"script": "res://Quests/the_reaper_of_ravenglass.gd",
		"stage1": "ChatNPC",
		"stage2": "NavigateExpedition",
		"stage3": "TalkToColin",
	},
	"EpicQuest" :{
		"script": "res://Quests/epic_quest.gd",
		"stage1": "ChatNPC",
		"stage2": "BrewPotion",
		"stage3": "StartExpedition",
		"stage4": "CollectExpedition",
	},
	"EpicQuest2" :{
		"script": "res://Quests/epic_quest2.gd",
		"stage1": "ChatNPC",
	},
	"ProgressQuest" :{
		"script": "res://Quests/progress_quest.gd",
		"stage1": "ChatNPC",
	},
	"GuntheidonQuest" :{
		"script": "res://Quests/guntheidon_quest.gd",
		"stage1": "ChatNPC",
	},
	"ProgressQuest2" :{
		"script": "res://Quests/progress_quest2.gd",
		"stage2": "CompleteResearch",
	}
}

func on_scene_changed():
		# Instantiate and add quest display to the scene tree
	quest_display = quest_display_scene.instantiate()
	var current_scene = get_tree().current_scene
	var Canvas = get_node("/root/Header/UI")
	Canvas.add_child(quest_display)

# Add a quest to active quests
func add_quest(quest_id: String):
	if active_quest != null:
		print("A quest is already active. Complete it before starting a new one.")
		return

	var quest_data = quests_data.get(quest_id, null)
	if quest_data == null:
		print("Quest ID not found: ", quest_id)
		return

	var quest_script = load(quest_data["script"])
	if quest_script:
		active_quest = quest_script.new()
		active_quest.start_quest()
		current_stage = 1
		update_quest_display()
		if quest_id == "TheReaperOfRavenglass":
			GameManager.npc.dialogue_file = "res://Quests/Dialogue/DialogueText/Reaper_of_Ravenglass_Dialogue.json"
			#print("Dialogue file: ", GameManager.npc.dialogue_file)
			GameManager.npc._load_dialogue()
		GameManager.npc.update_npc_sprite_based_on_active_quest()
		#print("Started quest: ", quest_id)
	else:
		print("Failed to load quest script: ", quest_data["script"])

# Method to update the quest display
func update_quest_display() -> void:
	if active_quest:
		var quest_name = active_quest.info["QuestDisplayName"]
		var quest_description = active_quest.info["QuestDescription"][current_stage]
		quest_display.update_quest(quest_name, quest_description)
	else:
		print("No active quest to display.")

# Progress the current active quest
func progress_active_quest():
	#print("progress_active_quest() called...")
	if active_quest != null:
		if current_stage < active_quest.max_stage:
			current_stage += 1
			print("current_stage: ", current_stage)
			active_quest.progress_quest(current_stage)
			update_quest_display()
			GameManager.play_sound("new_mission")
		else:
			complete_active_quest()
			GameManager.play_sound("mission_completed")

# Complete the current active quest
func complete_active_quest():
	#print("complete_active_quest() called...")
	if active_quest != null:
		#print("Completing quest: ", active_quest.quest_name)
		active_quest.complete_quest()
		completed_quests.append(active_quest.quest_name)
		
		GameManager.npc.clear_dialogue()
		
		if active_quest.quest_name == "SettlingIn":
			active_quest = null
			current_stage = 0
			add_quest("TheReaperOfRavenglass")
			GameManager.npc.dialogue_file = "res://Quests/Dialogue/DialogueText/Reaper_of_Ravenglass_Dialogue.json"
			GameManager.npc._load_dialogue()
		elif active_quest.quest_name == "TheReaperOfRavenglass":
			active_quest = null
			current_stage = 0
			add_quest("EpicQuest")
			GameManager.npc.dialogue_file = "res://Quests/Dialogue/DialogueText/Epic_Quest_Dialogue.json"
			GameManager.npc._load_dialogue()
		elif active_quest.quest_name == "EpicQuest":
			active_quest = null
			current_stage = 0
			add_quest("ProgressQuest")
			GameManager.npc.dialogue_file = "res://Quests/Dialogue/DialogueText/Progress_Quest_Dialogue.json"
			GameManager.npc._load_dialogue()
			var crystal_orb = GameManager.main_ui.get_node("MainScreen/ScreenBorders/BookShelf/GuntheidonOrb")
			if crystal_orb:
				print("crystal_orb found")
				crystal_orb.visible = true
			else:
				print("crystal_orb not found", crystal_orb)
		elif active_quest.quest_name == "ProgressQuest":
			active_quest = null
			current_stage = 0
			add_quest("GuntheidonQuest")
			GameManager.npc.dialogue_file = "res://Quests/Dialogue/DialogueText/Guntheidon_Quest_Dialogue.json"
			GameManager.npc._load_dialogue()
		elif active_quest.quest_name == "GuntheidonQuest":
			active_quest = null
			current_stage = 0
			add_quest("ProgressQuest2")
			GameManager.npc.dialogue_file = "res://Quests/Dialogue/DialogueText/Progress_Quest2_Dialogue.json"
			GameManager.npc._load_dialogue()
		
		GameManager.npc.update_npc_sprite_based_on_active_quest()
		
# Function to progress quest when chat with NPC
func on_NPC_chat():
	#print("active_quest.stage: ", current_stage)
	if active_quest.max_stage >= current_stage and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "ChatNPC":
		#print("on_NPC_chat() called, active_quest.stage: ", current_stage)
		GameManager.npc.update_sprite("res://Assets/Sprites/Characters/char_7_blank.png")
		if active_quest.quest_name == "SettlingIn":
			var garden_button = GameManager.main_ui.get_node("SceneButtons/GardenButton")
			if garden_button:
				garden_button.visible = true
		elif active_quest.quest_name == "EpicQuest":
			var alchemy_button = GameManager.main_ui.get_node("SceneButtons/AlchemyLabButton")
			if alchemy_button:
				alchemy_button.visible = true
		progress_active_quest()

# Function to progress quest when a plant is harvested
func on_plant_harvested():
	if active_quest and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "HarvestPlant":
		print("QuestManager: on_plant_harvested called")
		progress_active_quest()

# Function to progress quest when a monster is fed
func on_monster_fed():
	if active_quest and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "FeedMonster":
		progress_active_quest()

# Function to progress quest when a plant is harvested
func on_potion_brewed():
	if active_quest and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "BrewPotion":
		var expeditions_button = GameManager.main_ui.get_node("SceneButtons/ExpeditionsButton")
		if expeditions_button:
			expeditions_button.visible = true
		else:
			print("Expedition button not found: ", expeditions_button)
		progress_active_quest()

# Function to progress quest when an expedition is started
func on_expedition_started():
	if active_quest and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "StartExpedition":
		progress_active_quest()

# Function to progress quest when expedition rewards are collected
func on_expedition_rewards_collected():
	if active_quest and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "CollectExpedition":
		progress_active_quest()

func on_research_completed():
	if active_quest and quests_data[active_quest.quest_name]["stage" + str(current_stage)] == "CompleteResearch":
		progress_active_quest()
