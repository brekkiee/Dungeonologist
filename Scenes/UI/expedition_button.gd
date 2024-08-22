extends TextureButton

@export var expedition_bag_popup: Control
@export var adventurer_portrait: TextureRect
@export var adventure_animation: AnimatedSprite2D
@onready var expedition_timer = Timer.new()
@export var found_monster: Node2D

func _ready():
	add_child(expedition_timer)
			# Set timer properties
	expedition_timer.wait_time = 5 # Need to adjust as necessary
	expedition_timer.one_shot = true
	expedition_timer.connect("timeout", Callable(self, "_on_expedition_timer_timeout"))
	
func _on_pressed():
		if InventoryManager.item_mouse_follow != null:
			# If item from inventory selected and dragged to expedition portrait, click to add potion
			#ExpeditionManager.show_expedition_popup()
			expedition_bag_popup.visible = true
			InventoryManager.item_used_click()

func _on_start_expedition_button_pressed():
	expedition_bag_popup.visible = false
	adventurer_portrait.modulate = Color(0.3,0.3,0.3)
	adventure_animation.visible = true
	expedition_timer.start()

func _on_expedition_timer_timeout():
	adventurer_portrait.modulate = Color(1,1,1)
	adventure_animation.visible = false
	print("Expedition timer complete")
#	found_monster.visible = true
#	InventoryManager.add_potion_inventory_item("common_slime_item")
#	print("Common Slime added to inventory")
	# Access the Monster Enclosure scene via GameManager
#	var monster_enclosure_scene = GameManager.monster_enclosure_scene
#	if monster_enclosure_scene:
#		var found_monster = monster_enclosure_scene.get_node("MonsterSpawnPoint1")  # Replace with your monster's node name
#		if found_monster:
#			found_monster.visible = true
#			print("Monster made visible in Monster Enclosure")
	if GameManager.found_monster:
		GameManager.found_monster.visible = true
		print("Monster made visible in Monster Enclosure")
