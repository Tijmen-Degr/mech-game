extends Control

enum States {
	OPTIONS,
	TARGETS,
}

enum Actions {
	FIGHT,
}

enum {
	ACTOR,
	TARGET,
	ACTION,
}

var state: States = States.OPTIONS
var atb_queue: Array = []
var event_queue: Array = []
var action: Actions = Actions.FIGHT
var player: BattleActor = null

@onready var _options: WindowDefault = $Options 
@onready var _options_menu: Menu = $Options/Options
@onready var _enemies_menu: Menu = $Enemies
@onready var _players_menu: Menu = $Players
@onready var _players_info: Array = $GUIMargin/Bottom/Players/MarginContainer/VBoxContainer.get_children()
@onready var _cursor: MenuCursor = $MenuCursor
@onready var _players_buttons: Array = $Players.get_children()  # assumes all PlayerButt nodes are children

func _ready() -> void:
	_options.hide()
	
	for player_info in _players_info:
		player_info.atb_ready.connect(_on_player_atb_ready.bind(player_info))
		
	for enemy_butt in _enemies_menu.get_buttons():
		enemy_butt.atb_ready.connect(_on_enemy_atb_ready.bind(enemy_butt.data))
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match state:
			States.OPTIONS:
				pass
			States.TARGETS:
				state = States.OPTIONS
				_options_menu.button_focus()

func advance_atb_queue() -> void:
	state = States.OPTIONS
	if atb_queue.is_empty():
		return
		
	var current_player_info_bar: PlayerInfoBar = atb_queue.pop_front()
	current_player_info_bar.reset()
	# remove dead players from the queue
	atb_queue = atb_queue.filter(func(p):
		var idx = p.get_index()
		return Data.party[idx].has_hp()
	)
	
		# stop blinking for previous player
	var prev_index = Data.party.find(player)
	if prev_index >= 0:
		var prev_button: PlayerButt = _players_buttons[prev_index]
		prev_button.stop_blink()
	
	if atb_queue.is_empty():
		get_viewport().gui_release_focus()
		_options.hide()
		_cursor.hide()
	else:
		var next_player_info_bar: PlayerInfoBar = atb_queue.front()
		next_player_info_bar.highlight()  # info bar blink
		var next_index = next_player_info_bar.get_index()
		player = Data.party[next_index]
		
		# start blinking for the next player
		var next_button: PlayerButt = _players_buttons[next_index]
		next_button.start_blink()
		
		_options.show()
		_options_menu.button_focus(0)

func wait(duration: float):
	return await get_tree().create_timer(duration)

func run_event() -> void:
	if event_queue.is_empty():
		return

	await get_tree().create_timer(0.5).timeout

	if event_queue.is_empty():
		return

	var event: Array = event_queue.pop_front()
	var actor: BattleActor = event[ACTOR]
	var target: BattleActor = event[TARGET]
	
	if !actor.can_act():
		run_event()
		return
	
	if !target.has_hp():
		var target_is_friendly: bool = Data.party.has(target)
		var target_buttons: Array = []
		if target_is_friendly:
			target_buttons = _players_menu.get_buttons()
		else:
			target_buttons = _enemies_menu.get_buttons()
		
		target = null
		target_buttons.shuffle()
		for i in range(target_buttons.size()):
			var button: BattleActorButt = target_buttons[i]
			var data: BattleActor = button.data
			if data.has_hp():
				target = data
				break
		
		if target == null:
			#TODO battle end state, depending on which side won
			pass
		
	match event[ACTION]:
		Actions.FIGHT:
			target.healhurt(-actor.strength)
		_:
			pass
		
	#await wait(0.75)
	await get_tree().create_timer(0.25).timeout
	run_event()

func add_event(event: Array) -> void:
	event_queue.append(event)
	if event_queue.size() == 1:
		run_event()

func _on_options_button_pressed(button: BaseButton) -> void:
	match button.text:
		"Fight":
			action = Actions.FIGHT
			state = States.TARGETS
			_enemies_menu.button_focus()

func _on_player_atb_ready(player_info: PlayerInfoBar) -> void:
	var index = player_info.get_index()
	var actor: BattleActor = Data.party[index]

	if !actor.has_hp():
		return
	atb_queue.append(player_info)
	# only show options if queue was empty
	if atb_queue.size() == 1:
		var first_index = player_info.get_index()
		player = Data.party[first_index]
		player_info.highlight()
		
		# start blinking for the first player
		var first_button: PlayerButt = _players_buttons[first_index]
		first_button.start_blink()
		
		_options.show()
		_options_menu.button_focus(0)

func _on_enemy_atb_ready(enemy: BattleActor) -> void:
	var alive_players: Array = []

	for p in Data.party:
		if p.hp > 0:
			alive_players.append(p)

	if alive_players.is_empty():
		return # no valid targets (battle should probably end)
		#atb shouldn't empty and remain full

	var target: BattleActor = alive_players.pick_random()
	add_event([enemy, target, Actions.FIGHT]) #TODO choose action besides fight

func _on_enemies_button_pressed(button: EnemyButt) -> void:
	var target: BattleActor = button.data
	add_event([player, target, action])
		# stop blinking for the current player
	var player_index = Data.party.find(player)  # returns index of player in Data.party
	var player_butt: PlayerButt = _players_buttons[player_index]
	player_butt.stop_blink()
	advance_atb_queue()

func _on_players_button_pressed(button: PlayerButt) -> void:
	var target: BattleActor = button.data
	add_event([player, target, action])
	advance_atb_queue()
