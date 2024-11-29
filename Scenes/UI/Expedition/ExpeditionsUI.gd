extends Control

var popup = null
var rewardUI = null

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var button = $PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1/Button  # Adjust the node path if necessary

@onready var flyer_texture_normal = $PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1.texture
@onready var flyer_texture_highlighted = preload("res://Assets/Sprites/Expeditions/Expe_Page_Highlight.png")

@onready var flyer_texture_rect = $PC/ExpoditionBoard/TextureRect/HBoxContainer/Expedtion1

@onready var expedition_countdown = $ExpeditionCountdown  # Adjust the node path if necessary
@onready var countdown_label = $ExpeditionCountdown/CountdownLabel
@onready var expedition_anim = $ExpeditionCountdown/ExpeditionAnim

var countdown_time_remaining = 0.0
var countdown_timer = null

var level_1_expos = [
	preload("res://Expeditions/expo1.tres"),
	preload("res://Expeditions/expo2.tres")
]

var level_2_expos = {
	
}

var expoData: Expeditions

func _ready():
	button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	# Register this instance with ExpeditionManager
	ExpeditionManager.expeditionUI_instance = self

	popup = get_node("BagPopUp")  # Adjust the node path if necessary
	if popup == null:
		print("Error: 'BagPopUp' node not found")
	else:
		popup.DungeonName = "NULL"
		popup.DungeonFloor = "Floor 0"
		popup.AdventurerName = "Colin"
		popup.update(null)
		popup.visible = false

	rewardUI = ExpeditionManager.expeditionRewards  # Adjust the node path if necessary
	if rewardUI == null:
		print("Error: 'ExpeditionRewards' node not found")
	else:
		rewardUI.visible = false
	
	expedition_countdown.visible = false

func start_countdown(total_time):
	expedition_countdown.visible = true
	expedition_anim.play("adventuring")
	countdown_time_remaining = total_time
	countdown_label.text = format_time(countdown_time_remaining)
	if countdown_timer != null:
		countdown_timer.stop()
		remove_child(countdown_timer)
	countdown_timer = Timer.new()
	countdown_timer.wait_time = 1.0
	countdown_timer.one_shot = false
	countdown_timer.connect("timeout", Callable(self, "_on_countdown_timer_timeout"))
	add_child(countdown_timer)
	countdown_timer.start()

func _on_countdown_timer_timeout():
	countdown_time_remaining -= 1.0
	if countdown_time_remaining <= 0.0:
		countdown_label.text = "Expedition Complete"
		countdown_timer.stop()
		expedition_countdown.visible = false
	else:
		countdown_label.text = format_time(countdown_time_remaining)

func stop_countdown():
	if countdown_timer != null:
		countdown_timer.stop()
		remove_child(countdown_timer)
		countdown_timer = null
	expedition_countdown.visible = false

func format_time(seconds):
	seconds = int(seconds)
	var minutes = int(seconds / 60)
	seconds = int(seconds % 60)
	return "%dm %ds" % [minutes, seconds]

func show_rewards(rewards):
	rewardUI.visible = true
	rewardUI.expo_title = str(popup.DungeonName, " ", popup.DungeonFloor)
	rewardUI.expo_rewards = rewards
	rewardUI.show_rewards()

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)
	flyer_texture_rect.texture = flyer_texture_highlighted

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
	flyer_texture_rect.texture = flyer_texture_normal

func on_button_pressed_expo1():
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0, level_1_expos.size() -1)
	expoData = level_1_expos[index]
	if popup != null:
		popup.DungeonName = expoData.Dungeon
		popup.DungeonFloor = str(expoData.Floor)
		popup.AdventurerName = "Colin"
		popup.update(expoData)
		popup.visible = true
	else:
		print("Error: 'popup' is null.")
