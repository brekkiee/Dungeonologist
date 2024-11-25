extends Node

signal day_started(day_count)
signal night_started(day_count)

# Default values
var day_night_length: float = 50.0
var current_time: float = 0.0
var is_day: bool = true
var day_count: int = 1
var day_duration: float = day_night_length
var night_duration: float = day_night_length

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	_load_player_data()
	_initialize_time_mode()
	_start_current_cycle()
	get_tree().connect("about_to_quit", Callable(self, "_on_about_to_quit"))

# Load the saved player data to restore the time
func _load_player_data():
	print("DayNightCycle: _load_player_data called, current_time before: ", current_time)
	current_time = PlayerData.current_time
	print("current_time after: ", current_time)	
	is_day = PlayerData.is_day
	day_count = PlayerData.day_count

# Load the time mode and update the cycle length based on the mode
func _initialize_time_mode():
	var time_mode = PlayerData.get_time_mode()
	if time_mode == "":
		time_mode = "In-Game Time"
		PlayerData.set_time_mode(time_mode)
	update_time_mode(time_mode)

# Start the correct cycle based on whether it's day or night, without resetting time
func _start_current_cycle():
	if is_day:
		start_day(false)
	else:
		start_night(false)

func start_time_progression():
	process_mode = Node.PROCESS_MODE_INHERIT

func stop_time_progression():
	process_mode = Node.PROCESS_MODE_DISABLED

# Start the day cycle, without resetting the time if not required
func start_day(reset_current_time = true):
	is_day = true
	if reset_current_time:
		current_time = 0.0
	emit_signal("day_started", day_count)

# Start the night cycle, without resetting the time if not required
func start_night(reset_current_time = true):
	is_day = false
	if reset_current_time:
		current_time = 0.0
	emit_signal("night_started", day_count)
#	_award_monster()
	# Spawn pending monsters if the player is in the Monster Enclosure
	if GameManager.current_scene and GameManager.current_scene.name == "MonsterEnclosure":
		GameManager.spawn_pending_monsters()

# Process the time progression every frame
func _process(delta):
	current_time += delta
	if is_day and current_time >= day_duration:
		_on_day_cycle_complete()
	elif not is_day and current_time >= night_duration:
		_on_night_cycle_complete()

# Transition to the night cycle when the day completes
func _on_day_cycle_complete():
	start_night(true)

# Transition to the day cycle when the night completes
func _on_night_cycle_complete():
	day_count += 1
	
	print("DayNightCycle: _on_night_cycle_complete called, day_count: ", day_count)
	start_day(true)

# Format the time for display
func get_formatted_time() -> String:
	var total_in_game_cycle_duration = 12 * 3600.0  # 43200 seconds
	var cycle_duration = day_duration if is_day else night_duration
	var percentage_of_cycle = current_time / cycle_duration
	var in_game_current_time = percentage_of_cycle * total_in_game_cycle_duration
	var base_hour = 6 if is_day else 18
	var total_seconds_since_base = int(in_game_current_time)
	var hours = base_hour + int(total_seconds_since_base / 3600)
	var minutes = int((total_seconds_since_base % 3600) / 60)

	if hours >= 24:
		hours -= 24
	var period = "AM" if hours < 12 else "PM"
	var display_hours = hours % 12
	if display_hours == 0:
		display_hours = 12
	return "%02d:%02d %s" % [display_hours, minutes, period]

# Update the time mode, ensuring the correct cycle length is applied
func update_time_mode(time_mode: String):
	if time_mode == "Real-Time":
		day_night_length = 43200
	else:
		day_night_length = 60 * 5
	
	var old_duration = day_duration if is_day else night_duration
	
	day_duration = day_night_length
	night_duration = day_night_length
	
	var percentage_of_cycle
	if old_duration > 0:
		percentage_of_cycle = current_time / old_duration
	else:
		percentage_of_cycle = 0.0
	
	#current_time = percentage_of_cycle * (day_duration if is_day else night_duration)

# Save the current time when the game exits
func _on_about_to_quit():
	PlayerData.current_time = current_time
	PlayerData.is_day = is_day
	PlayerData.day_count = day_count
	PlayerData.save_data()

# Skip to the next day when the button is pressed
func skip_to_next_day():
	day_count += 1
	current_time = 0.0
	is_day = true
	emit_signal("day_started", day_count)
	print("Day skipped to: ", day_count)
	ExpeditionManager.complete_all_expeditions()
