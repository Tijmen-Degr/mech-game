extends Node

var enemies: Dictionary = {
	"Archer Front": BattleActor.new()
}

var players: Dictionary = {
	"Sniper": BattleActor.new(),
	"Priest": BattleActor.new(),
	"Duskwing": BattleActor.new(),
	"Balor": BattleActor.new()
}

var party: Array = players.values()

func _init() -> void:
	Util.set_keys_to_names(players)
	Util.set_keys_to_names(enemies)
	print(players.Balor.name)
