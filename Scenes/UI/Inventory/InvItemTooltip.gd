extends Control

var localization: Dictionary =  {
	"snackle_item": "Snackle",
	"snepper_item": "Snepper",
	"peepermint_item": "Peepermint",
	"elfroot_item": "Elfroot",
	"sunflower_item": "Sunflower",
	"berry_item": "Berry",
	"mushroom_item": "Mushroom",
	"minor_health_potion_item": "Minor Health Potion", 
	"minor_mana_potion_item": "Minor Mana Potion",
	"common_slime_item": "Common Slime"
}

func Config(item):
	get_node("M/V/ItemName").text = item.data.Name
	get_node("M/V/ItemType").text = ItemData.type.keys()[item.data.Type]
