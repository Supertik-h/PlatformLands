extends CharacterBody2D

var is_awake: bool = false  
var SPEED = 100  # Stała prędkość poruszania się
var facing_right = true  # Kierunek początkowy
var can_flip = true

@onready var tile_map: TileMap = $"../TileMap"
@onready var ray_cast_left_2d: RayCast2D = $RayCast2LeftD3
@onready var ray_cast_right_2d: RayCast2D = $RayCast2RightD2
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D



var tiles_to_remove = [
	Vector2i(421, 43), 
	Vector2i(421, 44),
	Vector2i(431, 43), 
	Vector2i(431, 44),   
]
var tiles_to_remove2 = [
	Vector2i(421, 41), 
	Vector2i(421, 42),
	  
]

func _ready() -> void:
	sprite.play("sitting")  # Panda zaczyna w pozycji siedzącej

func _on_lever_2_tiger_lever_activated() -> void:
	print("aktywowana")
	wake_up()

func wake_up():
	is_awake = true
	sprite.play("walking")
	print("Panda wstała!")
	Global.tiger_byl_o = true
	for tile_pos in tiles_to_remove:
		#tile_map.set_cell(0, tile_pos, -1) #to jest przod
		tile_map.set_cell(1, tile_pos, -1) # to tył
		
	for tile_pos in tiles_to_remove2:
		#tile_map.set_cell(0, tile_pos, -1) #to jest przod
		tile_map.set_cell(2, tile_pos, -1) # to tył

func _physics_process(delta: float) -> void:
	if is_awake:

		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if not $RayCast2D.is_colliding() and is_on_floor():
			#velocity.x = SPEED * -1
			flip()
			velocity.x = SPEED
		elif ray_cast_left_2d.is_colliding():
			flip()
			velocity.x = SPEED if facing_right else -SPEED
			#await get_tree().create_timer(0.5).timeout
		elif ray_cast_right_2d.is_colliding():
			flip()
			#await get_tree().create_timer(0.5).timeout
			velocity.x = SPEED if facing_right else -SPEED
		else:
			
			velocity.x = SPEED
			move_and_slide()


func flip():
	can_flip = false  # Zablokowanie kolejnych flipów na chwilę

	facing_right = not facing_right
	scale.x *= -1  # Obrócenie sprite'a
	SPEED *= -1  # Odwrócenie kierunku ruchu
	velocity.x = SPEED  # Aktualizacja prędkości

	print("Obrócona!")

	# Oczekiwanie 0.3 sekundy, zanim będzie można znów się obrócić
	await get_tree().create_timer(0.3).timeout
	can_flip = true


func _on_player_tiger_lever_activated() -> void:
	wake_up()
	print("tiger po raz drugi !!!!!!!!!!!!!!!!!!!")
