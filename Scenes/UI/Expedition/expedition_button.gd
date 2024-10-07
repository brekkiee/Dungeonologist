extends TextureButton

@export var expedition_bag_popup: Control
@export var adventurer_portrait: TextureRect
@export var adventure_animation: AnimatedSprite2D
@export var expedition_timer: Timer
@export var found_monster: Node2D 

var current_expo = 0

func _ready():
	add_child(expedition_timer)
			# Set timer properties
	expedition_timer.wait_time = 5 # Need to adjust as necessary
	expedition_timer.one_shot = true

