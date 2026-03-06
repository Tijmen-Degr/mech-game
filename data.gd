extends Node

var enemies: Dictionary = {
	"Archer Front": BattleActor.new()
}

var players: Dictionary = {
	"Sniper": BattleActor.new(50, 30),
	"Priest": BattleActor.new(70, 10),
	"Blackbeard": BattleActor.new(80, 25),
	"Barbarossa": BattleActor.new(100, 15)
}

var party: Array = players.values()

func _init() -> void:
	Util.set_keys_to_names(players)
	Util.set_keys_to_names(enemies)
	#print(players.Balor.name)
