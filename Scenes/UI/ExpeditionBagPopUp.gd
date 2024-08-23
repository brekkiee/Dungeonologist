extends Control

@export var PotionTexture: TextureRect
var MouseIn
var ItemName
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_panel_container_mouse_entered():
	MouseIn = true
	print("mouseIn")


func _on_button_pressed():
	print("ButtonPressed")
	if InventoryManager.item_mouse_follow != null:
		
		var DictItemAndName = InventoryManager.CheckItemHeld()
		var Item = DictItemAndName["Item"]
		var HeldItem = DictItemAndName["HeldItem"]
		ExpeditionManager.SetItem(HeldItem)
		InventoryManager.item_used_click()
		print(typeof(Item))
		PotionTexture.texture = Item


func _on_panel_container_mouse_exited():
	MouseIn = false


func _on_timer_timeout():
	PotionTexture.texture = null
	visible = true
