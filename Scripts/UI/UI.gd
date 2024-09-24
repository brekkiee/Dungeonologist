extends Control

@onready var monster_book_scene = preload("res://Quests/Codex/codex.tscn")
@onready var quest_book_scene = preload("res://Quests/Codex/QuestLog.tscn")
@onready var day_count_label = $DayCounterLabel
var monster_book
var monster_book_open = false

var quest_book
var quest_book_open = false

func _ready():
	DayNightCycle.connect("day_started", Callable(self, "_on_day_started"))
	update_day_counter(DayNightCycle.day_count)

func _on_day_started(day_count):
	update_day_counter(day_count)

func update_day_counter(day_count):
	day_count_label.text = "Day: " + str(day_count)

func _on_monster_book_pressed():
	print("Button pressed")
	if not monster_book_open:
		print("Opening Codex")
		monster_book_open = true
		monster_book = monster_book_scene.instantiate()
		print("Codex instantiated")
		call_deferred("add_child", monster_book)	
		print("Codex added to scene tree")
	elif monster_book_open:
		print("Closing Codex")
		monster_book.queue_free()
		monster_book_open = false

func _on_quest_book_pressed():
	print("Button pressed")
	if not quest_book_open:
		print("Opening QuestLog")
		quest_book_open = true
		quest_book = quest_book_scene.instantiate()
		print("Codex instantiated")
		call_deferred("add_child", quest_book)	
		print("Codex added to scene tree")
	elif quest_book_open:
		print("Closing Codex")
		quest_book.queue_free()
		quest_book_open = false
