extends Control

@onready var _options: WindowDefault = $Options 
@onready var _options_menu: Menu = $Options/Options

func _ready() -> void:
	_options_menu.button_focus(0)


func _on_options_button_focused(button: BaseButton) -> void:
	pass # Replace with function body.

func _on_options_button_pressed(button: BaseButton) -> void:
	print_debug(button.text)
