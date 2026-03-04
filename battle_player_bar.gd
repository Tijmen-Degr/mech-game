class_name BattlePlayerBar extends HBoxContainer

signal atb_ready()

@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _atb: ATB_bar = $ATB_bar

func _ready() -> void:
	_anim.play("RESET")
	
func highlight(on: bool = true) -> void:
	var anim: String = "highlight" if on else "RESET"
	_anim.play(anim)
	
func reset() -> void:
	highlight(false)
	_atb.reset()

func _on_atb_bar_filled() -> void:
	atb_ready.emit()
	#_anim.play("highlight")
