class_name EnemyButt extends TextureButton

const HIT_TEXT: PackedScene = preload("res://hit_text.tscn")

var data: BattleActor = Data.enemies["Archer Front"].duplicate()

@onready var _atb_bar: ATB_bar = $ATB_bar

func _ready() -> void:
	#TODO load sprite
	data.hp_changed.connect(_on_data_hp_changed)
	
func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	add_child(hit_text)
	hit_text.position = Vector2(size.x * 0.25, 4)
	
	if hp <= 0:
		await get_tree().create_timer(1.0).timeout
		queue_free()
