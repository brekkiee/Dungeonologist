class_name MonsterSpecies
extends Resource

@export var name: String
@export var diet: Array[String] = []
@export var habitats: Array[String] = []

@export_group("Meters Decline (Per Second)")
@export var hunger_rate = 5.0
@export var unhappy_rate = 5.0

@export_group("Movement Variables")
@export_subgroup("Walking")
@export var movement_speed = 1.0
@export var min_move_time = 0.5
@export var max_move_time = 5.0
@export_subgroup("Idle")
@export var min_idle_time = 0.5
@export var max_idle_time = 4.0
