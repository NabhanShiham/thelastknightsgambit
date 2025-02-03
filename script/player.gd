extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
const AIR_CONTROL = 1.0 # Air control factor (0.0 = no control, 1.0 = full control)
const ATTACK_COOLDOWN = 0.5

var health = 5
var attack_timer = 0.0

@onready var attack_ray = $RayCast2D

@onready var animation_player = $AnimatedSprite2D

@onready var enemy = get_node_or_null(".")

var keys_collected = 0

func _ready():
	pass

func collect_key():
	keys_collected += 1
	print("Gems collected: ", keys_collected)

func _physics_process(delta: float) -> void:
	if attack_timer > 0:
		attack_timer -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if direction != 0:
		velocity.x = direction * SPEED

		if direction < 0:
			animation_player.flip_h = true
			flip_ray(true)  
		elif direction > 0:
			animation_player.flip_h = false
			flip_ray(false)  

		animation_player.play("run")  
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation_player.play("idle") 

	if not is_on_floor():
		if AIR_CONTROL == 0.0:
			velocity.x = 0
		else:
			velocity.x = lerp(velocity.x, direction * SPEED, AIR_CONTROL)

	move_and_slide()

	if health <= 0:
		die()

	if Input.is_action_just_pressed("attack") and attack_timer <= 0:
		perform_attack()
		
func flip_ray(_should_flip):
	if not _should_flip:
		attack_ray.scale.x = 1
	if  _should_flip:
		attack_ray.scale.x = -1

func take_damage(amount: int) -> void:
	health -= amount
	print("Player health: ", health)
	if health <= 0:
		die()

func die() -> void:
	print("Player has died!")
	queue_free()
	GameManager.change_level()

func perform_attack() -> void:
	attack_timer = ATTACK_COOLDOWN
	print("Performed an attack!")
	if attack_ray.is_colliding():
		var enemy_ray = attack_ray.get_collider()
		enemy_ray.take_damage(3)
