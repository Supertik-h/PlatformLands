extends StaticBody2D

@export var disappear_time: float = 1.5  # Po 1.5 sekundy platforma zacznie znikać
@export var reappear_time: float = 3.0   # Po ilu sekundach platforma wróci
@onready var timer = $Timer

var is_disappearing: bool = false

func _ready():
	timer.wait_time = disappear_time
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if not Global.is_player_on_platform:
		is_disappearing = false
		return
	
	is_disappearing = true

	# Liczba mignięć zależna od disappear_time
	var blink_time = 0.15  # Czas jednego migania
	var blink_count = int(disappear_time / (2 * blink_time))  # Dzielimy przez 2x, bo mignięcie to ON/OFF
	
	for i in range(blink_count):
		visible = not visible
		await get_tree().create_timer(blink_time).timeout  

	visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	await get_tree().create_timer(reappear_time).timeout

	visible = true
	$CollisionShape2D.set_deferred("disabled", false)

	is_disappearing = false

	# Sprawdzenie, czy gracz nadal jest na platformie
	if Global.is_player_on_platform:
		timer.start()

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	if not is_disappearing:
		Global.is_player_on_platform = true
		timer.start()

func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	Global.is_player_on_platform = false
