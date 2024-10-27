class_name ItemData
extends Resource

enum type {Herb, Vegetable, Fruit, Fungi, Meat, Monster_Material, Potion}

@export var Name: String
@export var Type: type
@export var Sprite: Texture

@export_group("Drop Data")
@export_range(0.0,1.0) var drop_rate: float = 1.0
@export var min_quantity: int
@export var max_quantity: int

var Quantity: int

func item_save() -> Dictionary:
	var temp: Dictionary = {
		"Name": Name,
		"Quantity": Quantity
	};
	return temp;
