class_name ATB_bar extends ProgressBar

signal filled()

const SPEED_BASE: float = 0.05

@onready var _anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_anim.play("RESET")
	value = randf_range(min_value, max_value * 0.75)

func reset() -> void:
	_anim.stop()
	_anim.play("RESET") # or seek(0, true)
	modulate = Color.WHITE
	value = min_value
	set_process(true)

func _process(_delta: float) -> void:
	value += SPEED_BASE

	if value >= max_value:
		value = max_value
		set_process(false)
		_anim.play("highlight")
		filled.emit()
		#todo begin animation
