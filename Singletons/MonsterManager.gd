extends Node

# references
@onready var monster_enclosure_scene = preload("res://Scenes/monster_enclosure.tscn")

var enclosures = []

signal enclosuresUpdated

func addMonster(monster):
	for e in enclosures:
		# check if monster habitat matches enclosure habitat
		for h in enclosures[e]["habitat"]:
			for mh in monster["habitat"]:
				if enclosures[e][h] != null && enclosures[e][h] == monster[mh]:
					print(monster["name"] + " can live in " + enclosures[e][h])
					# add monster to enclosure
					enclosures[e] += monster
					enclosuresUpdated.emit()
					return true
				print("No suitable enclosure for " + monster["name"])
				return false
	print("Couldn't add new monster :(")
	return false

func addEnclosure(enclosure):
	enclosures += enclosure
	print (enclosures)
