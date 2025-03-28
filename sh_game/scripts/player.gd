extends CharacterBody2D

signal healthChanged

const SPEED = 180
const JUMP_VELOCITY = -300.0

var is_on_ladder = false  # Czy gracz jest na drabinie
var climb_speed = 200      # Prędkość wspinania się po drabinie
var move_speed = 150       # Prędkość poruszania się na boki
var gravity = 800          # Siła grawitacji

# Rolling
var is_rolling = false 
var roll_speed = 100
var roll_length = 0.1

# Double jump
var max_jump = 2


var jump_count = 0

# Wall jump and wall slide
const wall_jump_pushback = 100
const wall_slide_gravity = 80
var is_wall_sliding = false 

# Walka z golemem
var is_attacking = false  # Flaga ataku
var is_invincible = false

#Żyć czy nie żyć, oto jest pytanie
@export var  maxHealth = 3
@onready var currentHealth: int = maxHealth

var is_knocked_back = false

@export var invulnerability_time := 1.0  # Czas nietykalności po otrzymaniu obrażeń (sekundy)
@export var bounce_force := 250  # Siła odbicia od kolców
var can_take_damage := true  # Flaga sprawdzająca, czy można otrzymać obrażenia


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_map: TileMap = $"../TileMap"

#Zabawa z przyciskami
@onready var animation_brama: AnimationPlayer = $"../Brama_pierwsza/AnimationPlayer"

var test_czarny = false
var test_niebieski = false
var test_purple = false
@onready var animation_brama_2: AnimationPlayer = $"../Brama_druga/AnimationPlayer"
@onready var animation_brama_3: AnimationPlayer = $"../Brama_trzecia/AnimationPlayer"
@onready var animation_brama_4: AnimationPlayer = $"../Brama_czwarta/AnimationPlayer"
@onready var animation_brama_5: AnimationPlayer = $"../Brama_tut/AnimationPlayer"


@onready var animation_brama_niebieska: AnimationPlayer = $"../BlueBramka/AnimationPlayer"
@onready var animation_brama_niebieska_2: AnimationPlayer = $"../BlueBramka2/AnimationPlayer"
@onready var animation_brama_niebieska_3: AnimationPlayer = $"../BlueBramka3/AnimationPlayer"

#przyciski ale w secret_room
@onready var brama_s1: AnimationPlayer = $"../Brama/AnimationPlayer"
@onready var brama_s2: AnimationPlayer = $"../BlueBramka/AnimationPlayer"
@onready var brama_s3: AnimationPlayer = $"../Purple_brama/AnimationPlayer"

#dzwingnia w ogniu
@onready var brama_ogien: AnimationPlayer = $"../Brama/AnimationPlayer"

#Muzyka moim zyciem

@onready var gol: AnimationPlayer = $AnimationPlayer




#Naprawa błędu z zerująca sie panda
signal lever_activated  # Sygnał do aktywacji dźwigni
signal tiger_lever_activated


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "roll":
		is_rolling = false
		velocity.x = 0  # Zatrzymaj ruch poziomy po zakończeniu roll
	if animated_sprite.animation == "attack":
		is_attacking = false
	
	
#Zdrowie	
func _ready():
	print("Pobieranie zdrowia z Global:", Global.globalHealth)  
	currentHealth = Global.globalHealth  # Pobieramy globalne zdrowie
	healthChanged.emit(currentHealth)  # Emitujemy sygnał zmiany zdrowia	
	
	
func _physics_process(delta: float) -> void:
	#Eksperymenty ze zdrowiem !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	#if currentHealth == maxHealth:  # Sprawdzamy, czy zdrowie nie zostało jeszcze ustawione
	#	currentHealth = Global.player_health
	#	maxHealth = Global.max_health  # Jeśli maxHealth może się zmieniać
	#	healthChanged.emit(currentHealth)
	if Global.zebrano:
		Global.zebrano = false
		gol.play("pickup")
	if Global.umarto:
		Global.umarto = false
		gol.play("die")
	if Global.zebrano_klucz:
		Global.zebrano_klucz = false
		gol.play("pickup")	
		
		
		
	#print(velocity.x)
	if Global.changed:
		if Global.tiger_byl_o:
			tiger_lever_activated.emit()
		if Global.panda_byla_o:
			lever_activated.emit()
			print("po raz drugi")
		global_position = Global.last_entry_position
		await get_tree().create_timer(0.5).timeout
		Global.changed = false
		print("changed")
	
	is_on_ladder = check_ladder()
	$AnimatedSprite2D.sprite_frames.set_animation_loop("attack", false)  # Upewnij się, że animacja ataku nie jest zapętlona
	attack()  # Wywołanie funkcji ataku
	
	if is_on_ladder:
		handle_ladder_movement()
	else:
		# Dodaj grawitację, jeśli nie jesteś na drabinie
		if not is_on_floor():
			velocity.y += gravity * delta

	# Rolling
# Rolling
	var direction := Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("rolldown") and not is_rolling and Global.dash > 0:
		print("Dash!")
		animated_sprite.play("jump")
		is_rolling = true
		Global.dash -= 1
		
		if direction != 0:
			# Jeśli się poruszam, dashuje w kierunku ruchu
			if direction < 0:
				velocity.x = -roll_speed - 600
				print("lew")
			else:
				velocity.x = direction * roll_speed * 7
			
		else:
			# Jeśli stoję, dash w stronę, w którą patrzy postać
			if animated_sprite.flip_h:
				velocity.x = -roll_speed * 5  # W lewo
			else:
				velocity.x = roll_speed * 5   # W prawo

		print("Velocity:", velocity.x)
			
		await get_tree().create_timer(0.3).timeout
		is_rolling = false
		$AnimatedSprite2D.stop()



	#print("dir")
	#print(direction)
	
	# Obracanie sprite'a
	if direction > 0:
		$AttackArea.scale.x = abs($AttackArea.scale.x)
		animated_sprite.flip_h = false
	elif direction < 0:
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
		animated_sprite.flip_h = true
	
	# Animacje ruchu – odtwarzamy je tylko, gdy nie trwa atak ani roll
	if is_on_floor() and not is_rolling and not is_attacking:
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	elif not is_on_ladder and not is_rolling and not is_attacking:
		animated_sprite.play("jump")
		
	# Slide (bez zmian)
	
	
	var layer = 1 
	if get_tree().current_scene.name == "Tutorial":
		layer = 0 # Definiujemy warstwę, z której pobieramy dane
	var sliding_exit_boost = 150
	# Pobieramy kilka punktów pod postacią (środek, lewa i prawa stopa)
	var foot_positions = [
		tile_map.local_to_map(global_position + Vector2(0, 10)),  # Środek
		tile_map.local_to_map(global_position + Vector2(-5, 10)),  # Lewa stopa
		tile_map.local_to_map(global_position + Vector2(5, 10))  # Prawa stopa
	]
	# Sprawdzamy kafelki pod postacią
	# Sprawdzenie, czy gracz jest na pochylni
# Sprawdzenie, czy gracz jest na pochylni
	var sliding = false
	for foot_pos in foot_positions:
		var tile_data = tile_map.get_cell_tile_data(layer, foot_pos)
		if tile_data and tile_data.get_custom_data("slide"):
			sliding = true
			break

	# Jeśli wykryto pochylnię, gracz automatycznie ślizga się w prawo
	if sliding:
		print("slide")
		var slide_speed_x = 100  # Zwiększona prędkość pozioma
		var slide_acceleration = 20  # Szybsze przyspieszanie w prawo
		var slide_gravity = 150000  # Mocniejsze opadanie
		
		velocity.x = move_toward(velocity.x, slide_speed_x, slide_acceleration * delta)  # Płynne przyspieszanie
		velocity.y = min(velocity.y + slide_gravity * delta, slide_gravity)  # Silniejsza grawitacja

		# Animacja ślizgu
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")

		#else:
		#	# Sprawdzenie, czy gracz właśnie opuścił pochylnię
		#	if velocity.x > 0:  # Jeśli poruszał się w prawo
		#		velocity.y = -150  # Lekkie podbicie w górę









	if not is_on_ladder and not is_knocked_back and not is_rolling:  # Blokujemy ruch, jeśli jest odrzut
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		
	
	if Global.globalHealth == 0 and not is_dead:
		
		die()


	#check_slide()
	jump()
	wall_slide(delta)
	check_spikes()
	move_and_slide()
	
	#print(get_tree().current_scene.name)
	#Obslugaprzycisków, zeby wywoływały animacje bramy
	if test_czarny and get_tree().current_scene.name == "Tutorial" and Input.is_action_just_pressed("click"):
		animation_brama_5.play("pion_tut")
		
		
	elif test_czarny and get_tree().current_scene.name == "Secret_pokoj" and Input.is_action_just_pressed("click"):
		brama_s1.play("pierwsza")
	elif test_niebieski and get_tree().current_scene.name == "Secret_pokoj" and Input.is_action_just_pressed("click"):
		brama_s2.play("druga")
	elif brama_s3 and get_tree().current_scene.name == "Secret_pokoj" and Input.is_action_just_pressed("click"):
		brama_s3.play("trzecia")
		
	elif test_czarny and Input.is_action_just_pressed("click"):
		print("dziala")
		animation_brama.play("test")
		animation_brama_2.play("pion_2")
		animation_brama_3.play("poziom3")
		animation_brama_4.play("poziom5")
		
		
	elif test_niebieski and Input.is_action_just_pressed("click"):
		print("dziala")
		animation_brama_niebieska.play("poziom_1")
		animation_brama_niebieska_2.play("poziom2")
		animation_brama_niebieska_3.play("poziom4")
	
	
	
	#KONIEC PHYSIC PROCESS

func check_ladder() -> bool:
	var tile_pos = tile_map.local_to_map(global_position)
	for layer in range(tile_map.get_layers_count()):
		var tile_data = tile_map.get_cell_tile_data(layer, tile_pos)
		if tile_data and tile_data.get_custom_data("ladder"):
			return true
	return false

func handle_ladder_movement():
	var direction := Input.get_axis("move_left", "move_right")
	if Input.is_action_pressed("move_up"):
		velocity.y = -climb_speed  
	elif Input.is_action_pressed("move_down"):
		velocity.y = climb_speed  
	else:
		velocity.y = 0  
	if direction != 0:
		velocity.x = direction * SPEED
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AttackArea.scale.x = abs($AttackArea.scale.x)
	animated_sprite.play("jump")
	
func jump():
	if is_on_floor():
		jump_count = 0
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	elif not is_on_floor() and not is_on_wall() and Input.is_action_just_pressed("jump") and jump_count >= 1 and jump_count < max_jump:
		velocity.y = JUMP_VELOCITY + 70
		jump_count += 1
	elif is_on_wall() and Input.is_action_just_pressed("jump") and can_wall_jump():
		print("wall")
		if Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback
		elif Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
		else:
			velocity.y = JUMP_VELOCITY
			
func wall_slide(delta):
	if is_on_wall() and not is_on_floor():
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
			
var is_dead = false  # Flaga zapobiegająca wielokrotnemu wywołaniu die()

func check_spikes():
	var direction: float = Input.get_axis("move_left", "move_right") # Używane do ruchu jako float
	
	if not can_take_damage:
		return
	
	var knockback_direction = Vector2.ZERO # Osobna zmienna dla odrzutu
	if Input.is_action_pressed("move_right"):
		knockback_direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		knockback_direction = Vector2(-1, 0)
	
	var positions_to_check = [
		global_position,
		global_position + Vector2(0, -3),
		global_position + Vector2(3, 0),
		global_position + Vector2(-3, 0),
		global_position + knockback_direction * 8 # Używa knockback_direction
	]
	
	for pos in positions_to_check:
		var tile_pos = tile_map.local_to_map(pos)
		for layer in range(tile_map.get_layers_count()):
			var tile_data = tile_map.get_cell_tile_data(layer, tile_pos)
			if tile_data and tile_data.get_custom_data("spike"):
				take_damage(direction)
				return



		
		
		
		
		
		
		
		
func die():
	Global.umarto = true
	if is_dead:
		return
	is_dead = true  # Zapobiegamy wielokrotnemu wywołaniu

	print("Gracz umarł!")
	gol.play("die")
	await get_tree().create_timer(0.1).timeout  # Krótka pauza przed resetem

	# Resetujemy zdrowie gracza przed przeładowaniem sceny
	Global.globalHealth = maxHealth  

	get_tree().reload_current_scene()  # Przeładowujemy scenę

#Tutaj golem zabija gracza

func _on_obszar_do_zgonu_body_entered(body: CharacterBody2D) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if body.is_in_group("golems"):
		take_damage(direction)
	""" 
	if not is_invincible:
		currentHealth -= 1
		if currentHealth < 0:
			currentHealth = 3  # Resetujemy zdrowie (dla testu)
		Global.globalHealth = currentHealth  # Zapisujemy do globalnej zmiennej
		print("Nowe globalne zdrowie:", Global.globalHealth)  
		healthChanged.emit(currentHealth)
"""
	
func attack():
	var attack_speed = 350
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		is_invincible = true  # Gracz staje się chwilowo nietykalny
		animated_sprite.stop()
		animated_sprite.play("attack")
		is_rolling = true

		if animated_sprite.flip_h:
			velocity.x = -attack_speed + 200
		else:
			scale.x = abs($AttackArea.scale.x) 
			velocity.x = attack_speed - 200

		# Pobieramy obiekty znajdujące się w zasięgu ataku
		var bodies = $AttackArea.get_overlapping_bodies()
		for body in bodies:
			# Jeśli obiekt należy do grupy "golem", wywołujemy u niego funkcję diee()
			if body.is_in_group("golem"):
				body.diee()
				break  # Zabij tylko jednego golema

		await get_tree().create_timer(0.35).timeout
		animated_sprite.stop()
		is_attacking = false
		is_rolling = false
		is_invincible = false  # Po zakończeniu ataku gracz znów może otrzymywać obrażenia
		
		
		
		
# Testy funkcji take_damage, która mogłaby być wykorzystywana wielokrotnie i nadawała by bounce
func take_damage(direction: float):
	gol.play("gol")
	if is_invincible:  # Jeśli gracz jest nietykalny, nic się nie dzieje
		return

	# Odejmowanie zdrowia zgodnie z twoim systemem
	currentHealth -= 1
	if currentHealth < 0:
		currentHealth = 3  # Resetujemy zdrowie (dla testu)
	Global.globalHealth = currentHealth  # Zapisujemy do globalnej zmiennej
	print("Nowe globalne zdrowie:", Global.globalHealth)  
	healthChanged.emit(currentHealth)  # Emitowanie sygnału zmiany zdrowia

	# Ustawienie tymczasowej nietykalności
	is_invincible = true
	$InvulnerabilityTimer.start(invulnerability_time)

	# Jeśli kierunek jest zerowy (np. kolce), ustaw domyślny odrzut do góry
	if direction == 0:
		direction = 1  # Domyślnie odrzut w prawo

	bounce_away(direction)

func bounce_away(direction: float):
	is_knocked_back = true
	
	# Odwracamy kierunek i ustawiamy wektor odrzutu
	var bounce_direction = -direction  # Odpychamy w przeciwną stronę
	var bounce_vector = Vector2(bounce_direction, -1.2).normalized()  # Większy odrzut w górę

	# Ustawienie siły odrzutu
	velocity.y = bounce_vector.y * bounce_force * 1.5  # Większy skok = bardziej paraboliczny ruch
	velocity.x = bounce_vector.x * bounce_force * 1.2  # Silniejszy odrzut w bok

	print("Odrzut X:", velocity.x)

	# Stopniowe wygaszanie velocity.x zamiast nagłego zatrzymania
	await get_tree().create_timer(0.01).timeout  
	var reduction_factor = 0.9  # Możesz dostosować (im mniejsze, tym szybciej zwalnia)
	while is_knocked_back:
		if is_on_floor():  # Jeśli gracz dotknął ziemi, zatrzymujemy ruch
			velocity.x = 0
			break  
		velocity.x *= reduction_factor
		await get_tree().create_timer(0.05).timeout  # Krótkie przerwy, by efekt był płynny
		if abs(velocity.x) < 5:  # Minimalny próg, żeby uniknąć zawracania
			break  

	await get_tree().create_timer(0.15).timeout  
	is_knocked_back = false
	
	


func _on_invulnerability_timer_timeout() -> void:
	is_invincible = false
	can_take_damage = true



#przyciski

#czarny
func _on_blackbutton_body_entered(body: CharacterBody2D) -> void:
	print("stoje na czarnym")
	test_czarny = true

func _on_blackbutton_body_exited(body: CharacterBody2D) -> void:
	test_czarny = false
	
func on_gate_closing(body: CharacterBody2D) -> void:
	print("wypycham")
	var push_direction = Vector2.RIGHT if global_position.x < get_parent().global_position.x else Vector2.LEFT
	global_position -= push_direction * 20  # Przesuwamy gracza lekko w bok

#niebieski
func _on_blue_button_body_entered(body: Node2D) -> void:
	test_niebieski = true


func _on_blue_button_body_exited(body: Node2D) -> void:
	test_niebieski = false
	
	
func _on_purp_butt_body_entered(body: Node2D) -> void:
	test_purple = true # Replace with function body.


func _on_purp_butt_body_exited(body: Node2D) -> void:
	test_purple = false # Replace with function body.


#ograniczanie wall jump
func can_wall_jump() -> bool:
	var tile_map = get_parent().get_node("TileMap")  # Pobierz TileMap (zmień ścieżkę, jeśli jest inna)
	var layers = [0, 1, 2]  # Sprawdzamy warstwy 0 i 1
	
	# Sprawdzamy po której stronie postać dotyka ściany
	var check_direction = Vector2.LEFT if is_on_wall_only() and Input.is_action_pressed("move_left") else Vector2.RIGHT
	
	# Pozycja tile'a, który sprawdzamy
	var tile_pos = tile_map.local_to_map(global_position + check_direction * 8) 
	
	# Iterujemy po warstwach i sprawdzamy, czy któraś ma custom data "walljump"
	for layer in layers:
		var tile_data = tile_map.get_cell_tile_data(layer, tile_pos)
		if tile_data != null and tile_data.get_custom_data("walljump"):
			return true
	if Global.is_player_on_platform:
		return true	
	
	return false  # Jeśli żadna warstwa nie ma "walljump", zwracamy false

	
func check_slide():
	var tile_map = get_parent().get_node("TileMap")  # Pobierz TileMap
	var tile_layers = [0, 1, 2]  # Warstwy tilemapy do sprawdzenia

	# Pobranie pozycji tile pod graczem
	var tile_pos = tile_map.local_to_map(global_position + Vector2(0, 10))

	# Sprawdzenie każdej warstwy
	for tile_layer in tile_layers:
		var tile_data = tile_map.get_cell_tile_data(tile_layer, tile_pos)
		
		if tile_data and tile_data.get_custom_data("slide") and is_on_floor():
			print("Gracz ślizga się!")

			# Pobranie kierunku nachylenia na podstawie normalnej kafelka
			var tile_normal = tile_data.get_custom_data("slide_direction") if tile_data.has_custom_data("slide_direction") else Vector2.ZERO

			# Jeśli nie mamy zdefiniowanego kierunku, próbujemy domyślnie
			var slide_direction = tile_normal.x if tile_normal.x != 0 else (-1 if velocity.x < 0 else 1)

			# Zwiększanie prędkości w dół dla efektu ślizgania
			velocity.y = min(velocity.y + 500 * get_physics_process_delta_time(), 1000)  # Możesz dostosować wartości

			# Stopniowe zwiększanie prędkości poziomej w kierunku pochylenia
			velocity.x += slide_direction * 150 * get_physics_process_delta_time()

			# Obracanie postaci w kierunku ślizgania
			$AnimatedSprite2D.flip_h = slide_direction < 0
			break  # Przerwij pętlę, jeśli znaleziono działający kafelek


		else:
			print("Brak ślizgania")




func _on_area_2d_lever_ogien_activated() -> void:
	print("otiweram dzwignie")
	brama_ogien.play("COS")
