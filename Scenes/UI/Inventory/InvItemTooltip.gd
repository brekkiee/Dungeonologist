extends Control


func Config(item):
	get_node("M/V/ItemName").text = item.data.Name
	get_node("M/V/ItemType").text = ItemData.type.keys()[item.data.Type]
