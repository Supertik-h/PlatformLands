extends HBoxContainer


@onready var key_label: Label = $Panel/Label

var key_count: int = Global.klucze  # Liczba zebranych kluczy

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
	key_label.text = str(key_count)

func _physics_process(delta: float) -> void:
	key_count = Global.klucze
	update_keys_display()
