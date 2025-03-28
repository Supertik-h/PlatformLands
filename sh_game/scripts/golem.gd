extends CharacterBody2D

var SPEED = 30
const JUMP_VELOCITY = -400.0

var player_nearby = false
var facing_right = true

@onready var ray_cast_left_2d: RayCast2D = $RayCastLeft2D
@onready var ray_cast_right_2d: RayCast2D = $RayCastRight2D

func _ready() -> void:
	# Dodaj golema do grupy "golem", aby mógł być trafiany przez atak gracza
	add_to_group("golem")

func _physics_process(delta: float) -> void:
	# Grawitacja
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Obróć golema, jeśli nie wykrywa kolizji (RayCast2D) i jest na ziemi
	if not $RayCast2D.is_colliding() and is_on_floor():
		flip()
	if ray_cast_left_2d.is_colliding():
		flip()
	if ray_cast_right_2d.is_colliding():
		flip()
		

	velocity.x = SPEED
	move_and_slide()

func flip():
	facing_right = not facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1

# Funkcja wywoływana przez gracza, gdy golem zostanie trafiony
func diee():
	await get_tree().create_timer(0.1).timeout
	print("Golem umiera!")
	Global.zabite_golemy += 1
	print("zabite: ", Global.zabite_golemy)
	queue_free()

func _on_area_2d_body_entered(body: Node) -> void:
	# Możesz opcjonalnie wykorzystywać tę funkcję, aby ustawić player_nearby,
	# np. jeśli potrzebujesz dodatkowej logiki zależnej od obecności gracza
	if body.is_in_group("player"):
		player_nearby = true

func _on_area_2d_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false
