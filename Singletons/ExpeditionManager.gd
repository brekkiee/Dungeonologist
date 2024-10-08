extends Node

var expeditions = [] # List of active expeditions
var available_adventurers = {} # Dictionary of adventurers with their levels and stats
var expedition_slots = 1 # Number of expeditions that can be run simultaneously


	
#func show_expedition_popup():
#	expedition_bag_popup.visible = true
#	# Handle logic for showing the popup and initializing it with relevant data



func SetItem(ItemName: String): #set potion stats
	match ItemName:
		"Minor Mana Potion":
			print("Rare monster rates + 10%, Common monster rates - 20%")
		"Minor Health Potion":	
			print("Material carry capacity + 1")


func start_expedition(expoData, adventurer, potion):
	if expeditions.size() < expedition_slots:
		expeditions.append({
			"floor": expoData.Floor,
			"adventurer": adventurer,
			"potion": potion,
			"status": "in_progress",
			"time_started": Time.get_time_dict_from_system()
		})
		# Trigger expedition started
		print("Expedition started on floor ", expoData.Floor, " with adventurer ", adventurer, " and potion ", potion, "\nStarted at: ", expeditions[0].time_started)
		expoData.index = expeditions.size() - 1
		var timer := Timer.new()
		timer.one_shot = true
		timer.wait_time = expoData.time
		add_child(timer)
		expoData.set_timer(timer)
		
	else:
		print("No available slots for more expeditions.")

func complete_expedition(expedition_index):
	if expeditions[expedition_index]["status"] == "in_progress":
		# Handle expedition completion, determine loot, etc.
		expeditions[expedition_index]["status"] = "completed"
		print("Expedition completed:", expeditions[expedition_index])
		expeditions.remove_at(expedition_index)
