extends Node

var expeditions = []  # List of active expeditions
var available_adventurers = {}  # Dictionary of adventurers with their levels and stats
var expedition_slots = 1  # Number of expeditions that can be run simultaneously

var expeditionUI_instance = null  # This will be set by ExpeditionsUI.gd
var expeditionRewards = null # Set in the MainUI.GD
var skip_day_button_alert = null
var first_expedition = true

var newDay = true

func SetItem(ItemName: String):  # Set potion stats
	match ItemName:
		"Minor Mana Potion":
			print("Rare monster rates + 10%, Common monster rates - 20%")
		"Minor Health Potion":
			print("Material carry capacity + 1")

func start_expedition(expoData, adventurer, potion):
	if expeditions.size() < expedition_slots and newDay:
		newDay = false
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = expoData.time
		add_child(timer)
		expoData.set_timer(timer)
		expoData.index = expeditions.size()  # Set index before appending
		expeditions.append({
			"floor": expoData.Floor,
			"adventurer": adventurer,
			"potion": potion,
			"status": "in_progress",
			"time_started": Time.get_time_dict_from_system(),
			"expoData": expoData,
			"timer": timer
		})
		# Trigger expedition started
		print("Expedition started on floor ", expoData.Floor, " with adventurer ", adventurer, " and potion ", potion, "\nStarted at: ", expeditions[0].time_started)
		QuestManager.on_expedition_started()
		# Start the expedition countdown timer in the UI
		if expeditionUI_instance != null:
			expeditionUI_instance.start_countdown(expoData.time)
		skip_day_button_alert = GameManager.main_ui.get_node("SkipDayButton/Alert")
		if first_expedition:
			skip_day_button_alert.visible = true
			first_expedition = false
	else:
		print("No available slots for more expeditions.")

func complete_expedition(expedition_index: int, awarded_rewards: Array[RewardResource]):
	if expeditions[expedition_index]["status"] == "in_progress":
		expeditions[expedition_index]["status"] = "completed"
		print("Expedition completed:", expeditions[expedition_index])
		
		# Stop the countdown timer in the UI
		if expeditionUI_instance != null:
			expeditionUI_instance.stop_countdown()
		
		if expeditionUI_instance == null:
			print("Error: 'ExpeditionsUI' instance not set.")
		else:
			# Ensure it's visible
			expeditionUI_instance.visible = true

			# Set Variables in the Expedition Rewards then Show
			expeditionRewards.set_expo_title("Expedition Complete")
			expeditionRewards.set_expo_rewards(awarded_rewards)
			expeditionRewards.show_rewards()

		expeditions.remove_at(expedition_index)
		QuestManager.on_expedition_rewards_collected()

func complete_all_expeditions():
	var expeditions_copy = expeditions.duplicate()
	for expedition in expeditions_copy:
		if expedition['status'] == 'in_progress':
			var expoData = expedition['expoData']
			var timer = expedition['timer']
			timer.stop()
			expoData.finished()
	expeditions.clear()
	# Stop the countdown timer in the UI
	if expeditionUI_instance != null:
		expeditionUI_instance.stop_countdown()
