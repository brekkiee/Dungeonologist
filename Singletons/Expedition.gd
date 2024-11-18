class_name Expeditions
extends Resource

@export var Dungeon: String
@export var Floor: int
@export var time: float
@export var rewards: Array[RewardResource]
var timer: Timer
var index: int

var rng = RandomNumberGenerator.new()

func set_timer(iTimer):
	timer = iTimer
	timer.connect("timeout", finished)
	timer.start()

func finished():
	print("Expedition Completed, Starting Reward Distribution")

	var awarded_rewards: Array[RewardResource] = []
	var monster_awarded = false

	for r in rewards:
		var chance = r.chance
		var roll = rng.randi_range(0, 100)
		print(roll)
		if roll <= chance:
			if r.isItem:
				print("Reward ", r.item_data.Name, " has been given")
				print("Reward Quantity: ", r.quantity)
				print("Item Type: ", r.item_data.Type)
				for i in range(r.quantity):
					print(i)
					match r.item_data.Type:
						6:
							InventoryManager.add_potion_inventory_item(r.item_data)
						_:
							InventoryManager.add_plant_inventory_item(r.item_data)
				awarded_rewards.append(r)
			else:
				if not monster_awarded:
					GameManager.award_monster(r.monster_name.name)
					print("Monster Reward: ", r.monster_name.name, " has been awarded")
					monster_awarded = true
					awarded_rewards.append(r)
				else:
					print("Monster already awarded, skipping extra mons")

	ExpeditionManager.complete_expedition(index, awarded_rewards)
