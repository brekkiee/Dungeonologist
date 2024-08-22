extends Node

var expeditions = [] # List of active expeditions
var available_adventurers = {} # Dictionary of adventurers with their levels and stats
var expedition_slots = 1 # Number of expeditions that can be run simultaneously

#func show_expedition_popup():
#	expedition_bag_popup.visible = true
#	# Handle logic for showing the popup and initializing it with relevant data

func start_expedition(floor, adventurer, potion):
	if expeditions.size() < expedition_slots:
		expeditions.append({
			"floor": floor,
			"adventurer": adventurer,
			"potion": potion,
			"status": "in_progress"
		})
		# Trigger expedition started
		print("Expedition started on floor", floor, "with adventurer", adventurer, "and potion", potion)
	else:
		print("No available slots for more expeditions.")

func complete_expedition(expedition_index):
	if expeditions[expedition_index]["status"] == "in_progress":
		# Handle expedition completion, determine loot, etc.
		expeditions[expedition_index]["status"] = "completed"
		print("Expedition completed:", expeditions[expedition_index])
		expeditions.erase(expedition_index)
