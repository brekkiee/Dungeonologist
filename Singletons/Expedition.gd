class_name Expeditions
extends Resource

@export var Dungeon: String
@export var Floor: int
@export var time: float
@export var rewards: Array[RewardResource]
var timer: Timer
var index: int

var rng = RandomNumberGenerator.new()
var rewardUI = preload("res://Scenes/UI/Expedition/ExpeditionRewards.tscn")
func set_timer(iTimer):
	timer = iTimer
	timer.connect("timeout", finished)
	timer.start()
	

func finished():
	print("Expedition Completed, Starting Reward Distribution")
	
	for r in rewards:
		var chance = r.chance
		var roll = rng.randi_range(0,100)
		print(roll)
		if roll <= chance:
			if r.isItem:
				print("Reward ", r.item_data.Name, " has been given")
				print("Reward Quantity: ", r.quantity)
				for i in r.quantity:
					print(i)
					match ItemData.type.keys()[r.item_data.Type]:
						"Potion":
							InventoryManager.add_potion_inventory_item(r.item_data)
						_:
							InventoryManager.add_plant_inventory_item(r.item_data)
			else:
				GameManager.award_monster(r.monster_name.name)
							

	ExpeditionManager.complete_expedition(index, rewards)
