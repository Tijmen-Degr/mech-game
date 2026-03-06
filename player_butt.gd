class_name PlayerButt extends BattleActorButt

var blink_timer := 0.0
var blink_on := false
var blinking := false

@onready var explosion = $Explosion
@onready var selected: TextureRect = $Selected

func _ready():
	set_data(Data.party[get_index()])
	
	if explosion:
		explosion.hide()
		explosion.animation_finished.connect(_on_explosion_animation_finished)
		explosion.position = size / 2
		# Cursor setup
	if selected:
		selected.hide()
		
func _on_data_hp_changed(hp: int, change: int) -> void:
	super(hp, change)
	
	if hp <= 0:
		die()

func die():
	disabled = true
	self_modulate = Color(0.282, 0.282, 0.282, 1.0)
	explosion.show()
	explosion.play("explode")

func _on_explosion_animation_finished():
	explosion.hide()

func start_blink():
	blinking = true
	selected.show()
	blink_timer = 0.0
	blink_on = true

func stop_blink():
	blinking = false
	selected.hide()

func _process(delta):
	if blinking:
		blink_timer += delta
		if blink_timer > 0.5:  # blink every 0.5s
			blink_timer = 0.0
			blink_on = !blink_on
			selected.visible = blink_on
