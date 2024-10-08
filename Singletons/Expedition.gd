class_name Expeditions
extends Resource

@export var Dungeon: String
@export var Floor: int
@export var time: float
@export var rewards: Array[RewardResource]
var timer: Timer

func set_timer(iTimer):
	timer = iTimer
	timer.connect("timeout", finished)
	timer.start()
	

func finished():
	print("Expo Finished")
	pass
