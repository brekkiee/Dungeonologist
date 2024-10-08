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
	
	for r in rewards:
		var chance = r.chance
		var roll = rng.randi_range(0,100)
		print(roll)
		if roll <= chance:
			print("Reward ", r.item_data.Name, " has been given") 
	
	ExpeditionManager.complete_expedition(index)
