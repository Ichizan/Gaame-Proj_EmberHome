extends CharacterBody2D

const SPEED: float = 100.0 
const KNOCKBACK_FORCE: int = 150 
const ATTACK_RANGE: float = 30.0 
const HEALTH_PICKUP = preload("res://Scence/stuff/health_pickup.tscn")

var is_alive: bool = true
var health: int = 100
var strength: int = 10
var target = null

var is_hurt: bool = false
var is_attacking: bool = false
var can_attack: bool = true 
var last_dir: String = "down"
var unique_id: String = ""

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: Node2D = $HealthBar

func _ready() -> void:
	unique_id = GameManager.current_map + "_" + name
	if GameManager.dead_orcs.has(unique_id):
		queue_free()
		return
		
func _physics_process(delta: float) -> void:
	if not is_alive:
		return
		
	if is_hurt:
		move_and_slide()
		return
		
	if target:
		var distance = position.distance_to(target.position)
		if distance <= ATTACK_RANGE:
			if not is_attacking and can_attack:
				_do_attack()
		else:
			if not is_attacking:
				_run_towards_target()
	else:
		if not is_attacking:
			_play_anim("idle")
			velocity = Vector2.ZERO
			
	move_and_slide() 

# ----------------------------------------------------
# ระบบเดินและโจมตี
# ----------------------------------------------------
func _run_towards_target() -> void:
	var direction = (target.position - position).normalized()
	velocity = direction * SPEED 
	
	_update_direction(direction)
	_play_anim("run")

func _do_attack() -> void:
	is_attacking = true
	can_attack = false 
	velocity = Vector2.ZERO 
	
	var direction = (target.position - position).normalized()
	_update_direction(direction)
	_play_anim("attack")
	
	if target and target.has_method("take_damage"):
		target.take_damage(strength)
	
	await get_tree().create_timer(0.6).timeout
	if is_alive:
		is_attacking = false
		await get_tree().create_timer(1.5).timeout
		can_attack = true

# ----------------------------------------------------
# ระบบรับดาเมจและกระเด็น
# ----------------------------------------------------
func take_damage(damage: int, attacker_position: Vector2) -> void:
	if not is_alive or is_hurt:
		return
		
	health -= damage
	health_bar.update_health(health)
	
	var knockback_direction = (position - attacker_position).normalized()
	_update_direction(-knockback_direction) 
	
	if health <= 0:
		_die()
	else:
		is_hurt = true
		_play_anim("hurt")
		
		# เล่นเสียงโดนโจมตี
		AudioManager.play_sfx("OrcHit")
		
		velocity = knockback_direction * KNOCKBACK_FORCE
		
		await get_tree().create_timer(0.3).timeout 
		if is_alive:
			is_hurt = false
			velocity = Vector2.ZERO 

func _die() -> void:
	is_alive = false
	is_hurt = false
	velocity = Vector2.ZERO
	_play_anim("die")
	
	# เล่นเสียงตาย
	AudioManager.play_sfx("OrcDie")
	
	$CollisionShape2D.set_deferred("disabled", true)
	if $Sight.has_method("set_deferred"):
		$Sight.set_deferred("monitoring", false)

	if not GameManager.dead_orcs.has(unique_id):
		GameManager.dead_orcs.append(unique_id)

	GameManager.add_orc_kill()
	
	var pickup = HEALTH_PICKUP.instantiate()
	pickup.global_position = global_position 
	get_parent().add_child(pickup) 
	
# ----------------------------------------------------
# ฟังก์ชันแอนิเมชันและระยะมองเห็น
# ----------------------------------------------------
func _update_direction(dir: Vector2) -> void:
	if absf(dir.x) > absf(dir.y):
		last_dir = "right" if dir.x > 0 else "left"
	else:
		last_dir = "down" if dir.y > 0 else "up"

func _play_anim(action: String) -> void:
	animated_sprite_2d.play(action + "_" + last_dir)

func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "playerlv1" and is_alive:
		target = body

func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "playerlv1" and is_alive:
		target = null
