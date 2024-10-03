extends Node

signal day_started(day_count)
signal night_started(day_count)

var day_night_length: float = 50.0 #43200.0 # 12h*60m*60s 12 hours cycles

var day_duration: float = day_night_length  # Duration of a day in seconds
var night_duration: float = day_night_length  # Duration of a night in seconds

var current_time: float = 0.0
var is_day: bool = true
var day_count: int = 1  # Tracks the number of days passed

func _ready():
	# Initially disable processing time, until start game
	process_mode = Node.PROCESS_MODE_DISABLED
	
	# Load time data from PlayerData
	current_time = PlayerData.current_time
	is_day = PlayerData.is_day
	day_count = PlayerData.day_count
	print("current_time", current_time)
	print("is_day", is_day)
	print("day_count", day_count)
	
	# Load the player's time mode preference
	var time_mode = PlayerData.get_time_mode()
	if time_mode == "":
		time_mode = "In-Game Time"  # Default mode
		PlayerData.set_time_mode(time_mode)
	
	update_time_mode(time_mode)
	print("time_mode", time_mode)
	
	# Start the cycle without resetting current_time
	if is_day:
		start_day(false)
	else:
		start_night(false)
	
	# Connect to the about_to_quit signal to save data on exit
	get_tree().connect("about_to_quit", Callable(self, "_on_about_to_quit"))

func _enter_tree():
	print("DayNighyCycle: _enter_tree called")
	get_tree().connect("about_to_quit", Callable(self, "_on_about_to_quit"))
	print("DayNightCycle: Connected to about_to_quit signal")

func start_time_progression():
	process_mode = Node.PROCESS_MODE_INHERIT
	print("DayNightCycle: Time progression started.")

func stop_time_progression():
	process_mode = Node.PROCESS_MODE_DISABLED
	print("DayNightCycle: Time progression started.")

func start_day(reset_current_time = true):
	is_day = true
	if reset_current_time:
		current_time = 0.0
	print("Day ", day_count, " has started.")
	emit_signal("day_started", day_count)
	#set_process(true)  # Start processing, update current_time

func start_night(reset_current_time = true):
	is_day = false
	if reset_current_time:
		current_time = 0.0
	print("Night ", day_count, " has started.")
	emit_signal("night_started", day_count)
	
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
	
	#set_process(true) # Continue processing, update current_time

func _process(delta):
	current_time += delta
	if is_day:
		if current_time >= day_duration:
			_on_day_cycle_complete()
	else:
		if current_time >= night_duration:
			_on_night_cycle_complete()

func _on_day_cycle_complete():
	#set_process(false) # Stop processing time til next cycle
	start_night()

func _on_night_cycle_complete():
	#set_process(false) # Stop processing time til next cycle
	day_count += 1
	print("Day Count: ", day_count)
	start_day()

func get_formatted_time():
	# Total in-game duration of a day or night cycle in seconds (12 hours)
	var total_in_game_cycle_duration = 12 * 3600.0  # 12 hours * 3600 seconds/hour = 43200 seconds
	# Get current cycle's duration
	var cycle_duration = day_duration if is_day else night_duration
	# Calculate percentage of current cycle that has passed
	var percentage_of_cycle = current_time / cycle_duration
	# Calculate in-game current time in seconds since start of cycle
	var in_game_current_time = percentage_of_cycle * total_in_game_cycle_duration
	# get base hour (6AM for day, 6PM for night)
	var base_hour = 6 if is_day else 18  # 6 AM or 6 PM
	# Calculate total seconds since base hour
	var total_seconds_since_base = int(in_game_current_time)
	# Calculate hours and minutes
	var hours = base_hour + int(total_seconds_since_base / 3600)
	var minutes = int((total_seconds_since_base % 3600) / 60)
	
	# Adjust hours if exceeds 24
	if hours >= 24:
		hours -= 24
	# Determine AM/PM period
	var period = "AM" if hours < 12 else "PM"
	# Convert to 12-hour format
	var display_hours = hours % 12
	if display_hours == 0:
		display_hours = 12

	# Return the formatted time
	return "%02d:%02d %s" % [display_hours, minutes, period]

func update_time_mode(time_mode):
	# Calculate % of current cycle already passed before change time mode
	var previous_cycle_duration = day_duration if is_day else night_duration
	var percentage_of_cycle = current_time / previous_cycle_duration
	
	if time_mode == "Real-Time":
		day_night_length = 43200.0 # 12 hour cycles in seconds
	else:
		day_night_length = 5.0 # In-Game time duration in seconds
	
	day_duration = day_night_length
	night_duration = day_night_length
	
	# Adjust current_time - reflect same % in new cycle duration
	var new_cycle_duration = day_duration if is_day else night_duration
	current_time = percentage_of_cycle * new_cycle_duration

func _on_about_to_quit():
	print("DayNightCycle: _on_about_to_quit called")
	# Save current time data
	PlayerData.current_time = current_time
	PlayerData.is_day = is_day
	PlayerData.day_count = day_count
	PlayerData.save_data()
