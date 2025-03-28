extends HBoxContainer


@onready var label: Label = $Panel/Label

var key_count: int = Global.dash  # Liczba zebranych kluczy

func _ready() -> void:
	update_keys_display()

func add_key() -> void:
	key_count += 1
	update_keys_display()

func remove_key() -> void:
	if key_count > 0:
		key_count -= 1
	update_keys_display()

func update_keys_display() -> void:
	label.text = str(key_count)

func _physics_process(delta: float) -> void:
	key_count = Global.dash
	update_keys_display()
