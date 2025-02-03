extends CharacterBody2D

const ATTACK_COOLDOWN = 3
# Patrol variables
var patrol_speed = 800
var patrol_range = 50
var direction = 1
var start_position : Vector2
var health = 5
var attack_timer = 0.0
@export var detection_range = 300

@onready var animated_mage = $AnimatedSprite2D
@export var attack_ray : RayCast2D


func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if attack_timer > 0:
		attack_timer -= delta

	var target_position = start_position + Vector2(patrol_range * direction, 0)
		
	var movement = (target_position - position).normalized() * patrol_speed * delta
	velocity.x = movement.x  
	move_and_slide()

	if position.distance_to(target_position) < 10:
		direction *= -1
		
	if direction < 0:
		animated_mage.animation = "walkLeft"
		flip_ray(false)
	elif direction > 0:
		animated_mage.animation = "walkRight"
		flip_ray(true)
	
	if attack_ray.is_colliding() and attack_timer <=0:
		perform_attack()
		print("Collision Detected!")
		
func flip_ray(_should_flip):
	if not _should_flip:
		attack_ray.scale.x = 1
	if  _should_flip:
		attack_ray.scale.x = -1
	
func perform_attack() -> void:
	attack_timer = ATTACK_COOLDOWN
	print("Enemy attacked!")
	
	if attack_ray.is_colliding():
		var collider = attack_ray.get_collider()
		
		# Check if the collider is the player
		if collider:  # Assuming player is in the "Player" group
			collider.take_damage(1)  # Apply damage to the player
		else:
			print("Attack hit something other than the player.")
	
func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy health: ", health)
	if health <= 0:
		die()

func die() -> void:
	print("Enemy has died!")
	queue_free()
	# Trigger level change in the GameManager or level system
	GameManager.enemy_killed()
