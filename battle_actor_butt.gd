class_name BattleActorButt extends TextureButton

const HIT_TEXT: PackedScene = preload("res://hit_text.tscn")

var data: BattleActor = null

func set_data(value: BattleActor) -> void:
	data = value
	#TODO load sprite 
	data.hp_changed.connect(_on_data_hp_changed)
	
func _on_data_hp_changed(hp: int, change: int) -> void:
	var hit_text: Label = HIT_TEXT.instantiate()
	hit_text.text = str(abs(change))
	add_child(hit_text)
	hit_text.position = Vector2(size.x * 0.25, 4)
	
