extends TextureButton

@export var expedition_bag_popup: Control
@export var adventurer_portrait: TextureRect
@export var adventure_animation: AnimatedSprite2D
@export var expedition_timer: Timer
@export var found_monster: Node2D 

var expedition_number: int = 0

func _ready():
	add_child(expedition_timer)
			# Set timer properties
	expedition_timer.wait_time = 5 # Need to adjust as necessary
	expedition_timer.one_shot = true
	
func _on_pressed():
		if InventoryManager.item_mouse_follow != null:
			# If item from inventory selected and dragged to expedition portrait, click to add potion
			ExpeditionManager.show_expedition_popup()
			expedition_bag_popup.visible = true
			InventoryManager.item_used_click()

func _on_start_expedition_button_pressed():
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
#	if GameManager.found_monster:
#		GameManager.found_monster.visible = true
#		print("Monster made visible in Monster Enclosure")
	if expedition_number == 0:
		GameManager.award_monster("plains_imp")
		PlayerData.research_tasks_completed["Plains Imp"][0] = true
		PlayerData.save_data()
		print("Research task 'Plains Imp' completed")
	elif expedition_number == 1:
		GameManager.award_monster("common_shrooman")
		GameManager.award_monster("common_shrooman")
		PlayerData.research_tasks_completed["Common Shrooman"][0] = true
		PlayerData.save_data()
		print("Research task 'Common Shrooman' completed")
	elif expedition_number == 2:
		GameManager.award_monster("nekomata")
		PlayerData.research_tasks_completed["Nekomata"][0] = true
		PlayerData.save_data()
	elif expedition_number == 3:
		GameManager.award_monster("forest_dinglebat")
		PlayerData.save_data()
	elif expedition_number == 4:
		GameManager.award_monster("forest_dinglebat")
		PlayerData.research_tasks_completed["Forest Dinglebat"][0] = true
		PlayerData.save_data()
	expedition_number += 1

