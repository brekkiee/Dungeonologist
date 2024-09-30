class_name ItemDrop
extends Resource

@export var item_name: String
@export_range(0.0,1.0) var drop_rate: float = 1.0
@export var min_quantity: int = 1
@export var max_quantity: int = 1
@export var type: String
@export var uses: Array[String] = []
@export var drop_location: String
# Unlock conditions: 0 = N/A, 1 = Floor 1, 2 = Floor 2, 3 = Floor 3
@export var unlock_condition: int
