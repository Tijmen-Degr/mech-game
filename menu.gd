class_name Menu extends Control

signal button_focused(button: BaseButton)
signal button_pressed(button: BaseButton)

@export var auto_wrap: bool = true

var index: int = 0
var exiting: bool = false

func _ready() -> void:
	tree_exiting.connect(_on_tree_exiting)
	
	for button in get_buttons():
		button.focus_exited.connect(_on_Button_focus_exited.bind(button))
		button.focus_entered.connect(_on_Button_focused.bind(button))
		button.pressed.connect(_on_Button_pressed.bind(button))
		button.tree_exiting.connect(_on_Button_tree_exiting.bind(button))

func get_buttons_count() -> int:
	return get_child_count()

func get_buttons() -> Array:
	return get_children()

func connect_to_buttons(target: Object, _name: String = name) -> void:
	var callable: Callable = Callable()
	callable = Callable(target, "_on_" + _name + "_focused")
	button_focused.connect(callable)
	callable = Callable(target, "_on_" + _name + "_pressed")
	button_pressed.connect(callable)

func button_enable_focus(on: bool) -> void:
	var mode: FocusMode = FocusMode.FOCUS_ALL if on else FocusMode.FOCUS_NONE
	for button in get_buttons():
		button.set_focus_mode(mode)

func button_focus(n: int = index) -> void:
	await get_tree().process_frame
	if get_buttons_count() > 0:
		button_enable_focus(true)
		n = clampi(n, 0, get_buttons_count() - 1)
		var button: BaseButton = get_buttons()[n]
		button.grab_focus()

func _on_Button_focus_exited(_button: BaseButton) -> void:
	await get_tree().process_frame
	if exiting:
		return
	
	if not get_viewport().gui_get_focus_owner() in get_buttons():
		button_enable_focus(false)
	#button.grab_focus()

func _on_Button_focused(button: BaseButton) -> void:
	index = button.get_index()
	emit_signal("button_focused", button)

func _on_Button_pressed(button: BaseButton) -> void:
	emit_signal("button_pressed", button)

func _on_Button_tree_exiting(button: BaseButton) -> void:
	if get_viewport().gui_get_focus_owner() == button:
		button_focus(index - 1)

func _on_tree_exiting() -> void:
	exiting = true
