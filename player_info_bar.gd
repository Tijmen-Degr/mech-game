class_name PlayerInfoBar extends HBoxContainer

signal atb_ready()

@onready var data: BattleActor = Data.party[get_index()]
@onready var _name: Label = $Name
@onready var _health: Label = $Health
@onready var _energy: Label = $Energy
@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _atb: ATB_bar = $ATB_bar

func _ready() -> void:
	_anim.play("RESET")
	_name.text = data.name
	_health.text = str(data.hp)
	_energy.text = str(data.mp)
	
	# Connect to hp_changed to update the health label
	data.hp_changed.connect(_on_hp_changed)
func highlight(on: bool = true) -> void:
	var anim: String = "highlight" if on else "RESET"
	_anim.play(anim)
	
func reset() -> void:
	highlight(false)
	_atb.reset()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
	#_anim.play("highlight")

func _on_hp_changed(hp: int, change: int) -> void:
	_health.text = str(hp)

	if hp <= 0:
		_atb.set_process(false) # stops ATB bar from filling
