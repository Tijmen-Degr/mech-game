class_name ATB_bar extends ProgressBar

signal filled()

const SPEED_BASE: float = 0.05

func _ready() -> void:
	value = randf_range(min_value, max_value * 0.75)

func _process(_delta: float) -> void:
	value += SPEED_BASE

	if is_equal_approx(value, max_value):
		set_process(false)
		filled.emit()
		#todo begin animation
