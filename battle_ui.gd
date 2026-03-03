extends Control

enum States {
	OPTIONS,
	TARGETS,
}

var state: States = States.OPTIONS
var atb_queue: Array = []
var event_queue: Array = []

@onready var _options: WindowDefault = $Options 
@onready var _options_menu: Menu = $Options/Options
@onready var _enemies_menu: Menu = $Enemies
@onready var _players_menu: Menu = $Players
@onready var _players_info: Array = $GUIMargin/Bottom/Players/MarginContainer/VBoxContainer.get_children()

func _ready() -> void:
	_options.hide()
	
	for player in _players_info:
		player.atb_ready.connect(_on_player_atb_ready.bind(player))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match state:
			States.OPTIONS:
				pass
			States.TARGETS:
				state = States.OPTIONS
				_options_menu.button_focus()

func _on_options_button_focused(button: BaseButton) -> void:
	pass # Replace with function body.

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.text:
		"Fight":
			state = States.TARGETS
			_enemies_menu.button_focus()

func _on_player_atb_ready(player: BattlePlayerBar) -> void:
	if atb_queue.is_empty():
		player.highlight(true)
		_options.show()
		_options_menu.button_focus(0)
		
	atb_queue.append(player)
	
