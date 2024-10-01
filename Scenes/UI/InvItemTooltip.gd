extends Control

var localization: Dictionary =  {
	"dawn_grass_item" : "Dawn Grass",
	"thimbleweed_item" : "Thimbleweed",
	"inkberry_item" : "Inkberry",
	"sweetroot_item" : "Sweetroot",
	"slime_residue_item" : "Slime Residue",
	"minor_health_potion_item" : "Minor Health Potion",
	"blood_cap_item" : "Blood Cap",
	"sentient_moss_item" : "Sentient Moss",
	"shroom_spores_item" : "Shroom Spores",
	"rotten_fruit_item" : "Rotten Fruit",
	"imp_droppings_item" : "Imp Droppings",
	"minor_mana_potion_item" : "Minor Mana Potion",
	"minor_stamina_potion_item" : "Minor Stamina Potion",
	"dwarven_nettle_item" : "Dwarven Nettle",
	"gelatinous_blob_item" : "Gelatinous Blob",
	"lucky_coin_item" : "Lucky Coin"
}

func Config(item):
	get_node("M/V/ItemName").text = localization[item.ItemName]
	get_node("M/V/ItemType").text = item.ItemType
