extends Node

signal day_started(day_count)
signal night_started(day_count)

var day_duration: float = 1.0  # Duration of a day in seconds
var night_duration: float = 1.0  # Duration of a night in seconds
var current_time: float = 0.0
var is_day: bool = true
var day_count: int = 1  # Tracks the number of days passed

var day_timer: Timer
var night_timer: Timer

func _ready():
	# Initialize timers
	day_timer = Timer.new()
	night_timer = Timer.new()
	add_child(day_timer)
	add_child(night_timer)

	day_timer.one_shot = true
	night_timer.one_shot = true

	day_timer.wait_time = day_duration
	night_timer.wait_time = night_duration

	day_timer.connect("timeout", Callable(self, "_on_day_timer_timeout"))
	night_timer.connect("timeout", Callable(self, "_on_night_timer_timeout"))

func start_day():
	is_day = true
	print("Day ", day_count, " has started.")
	emit_signal("day_started", day_count)
	day_timer.start()

func start_night():
	is_day = false
	print("Night ", day_count, " has started.")
	emit_signal("night_started", day_count)
	night_timer.start()
	# Award a monster to player, in pending monsters, ready to spawn
	if day_count <= GameManager.monsters_to_spawn.size():
		var monster_scene = GameManager.monsters_to_spawn[day_count - 1]
		GameManager.award_monster(monster_scene)
		print("Awarded a monster on night ", day_count)
	else:
		print("No more monsters to award.")
	# If player is in Monster Enclosure, spawn pending monsters
	if GameManager.current_scene and GameManager.current_scene.name == "MonsterEnclosure":
		GameManager.spawn_pending_monsters()

func _on_day_timer_timeout():
	start_night()

func _on_night_timer_timeout():
	day_count += 1
	print("Day Count: ", day_count)
	start_day()
