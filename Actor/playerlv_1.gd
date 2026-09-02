extends CharacterBody2D

#----------------------------------------------------
# การตั้งค่าตัวแปร (Variables Setup)
#----------------------------------------------------
signal died
signal health_changed(new_health : int)

const SPEED = 200.0

var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var is_hurt: bool = false
var hitbox_offset: Vector2
var can_move = true

var alive: bool = true
var max_health: int = 100
var health: int 
var strength: int = 20

# ตัวหน่วงเวลาเสียงเดิน
var footstep_timer: float = 0.0
const FOOTSTEP_INTERVAL: float = 0.35 

@onready var anim_lv1: AnimatedSprite2D = $AnimatedLv1
@onready var anim_lv2: AnimatedSprite2D = $AnimatedLv2
@onready var hitbox: Area2D = $Hitbox
@onready var damage_cooldown: Timer = $DamageCoolDown
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var current_anim: AnimatedSprite2D

#----------------------------------------------------
# ทำงานครั้งแรกเมื่อโหลดตัวละคร (Ready)
#----------------------------------------------------
func _ready() -> void:
	hitbox_offset = hitbox.position
	max_health = PlayerStats.max_health 
	
	if GameManager.is_loading_from_save:
		global_position = Vector2(GameManager.player_pos_x, GameManager.player_pos_y)
		health = GameManager.player_health
		PlayerStats.health = health 
		GameManager.is_loading_from_save = false
	else:
		health = PlayerStats.health
		
	if GameManager.has_lv2_suit:
		anim_lv1.visible = false
		anim_lv2.visible = true
		current_anim = anim_lv2
		strength = 40
	else:
		anim_lv1.visible = true
		anim_lv2.visible = false
		current_anim = anim_lv1
		strength = 20

	health_changed.emit(health)

#----------------------------------------------------
# วงจรการทำงานหลักของตัวละคร (Physics Process)
#----------------------------------------------------
func _physics_process(delta: float) -> void:
	if GameManager.is_in_dialogue:
		velocity = Vector2.ZERO
		move_and_slide()
		return 
		
	if not alive:
		return
		
	if is_hurt:
		move_and_slide()
		return
		
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
		
	process_movement(delta)
	process_animation()
	move_and_slide()

#----------------------------------------------------
# ระบบจัดการการเคลื่อนที่และแอนิเมชัน
#----------------------------------------------------
func process_movement(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		return
		
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		update_hitbox_offset()
		
		# ระบบเล่นเสียงเดินแบบมี Timer ป้องกันเสียงซ้อน
		footstep_timer += delta
		if footstep_timer >= FOOTSTEP_INTERVAL:
			footstep_timer = 0.0
			if GameManager.current_map == "boss" or GameManager.current_map == "FinalCave":
				AudioManager.play_sfx("Stonewalk")
			else:
				AudioManager.play_sfx("mainwalk")
	else:
		velocity = Vector2.ZERO
		footstep_timer = 0.0 # รีเซ็ตเวลาเมื่อหยุดเดิน
		
	if velocity != Vector2.ZERO:
		ray_cast_2d.target_position = velocity.normalized() * 50

func process_animation() -> void:
	if is_attacking:
		play_animation("attack", last_direction)
		return 
		
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else: 
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if absf(dir.x) > absf(dir.y):
		current_anim.flip_h = dir.x < 0
		current_anim.play(prefix + "_right")
	else:
		current_anim.flip_h = false
		if dir.y < 0:
			current_anim.play(prefix + "_up")
		elif dir.y > 0:
			current_anim.play(prefix + "_down")

#----------------------------------------------------
# ระบบโจมตีและอัปเดต Hitbox
#----------------------------------------------------
func attack() -> void:
	is_attacking = true
	update_hitbox_offset()
	hitbox.force_update_transform()
	
	# เล่นเสียงฟัน
	AudioManager.play_sfx("Slash")
	
	var enemies = hitbox.get_overlapping_bodies()
	for enemy in enemies:
		if enemy == self:
			continue
		if enemy.has_method("take_damage"):
			enemy.take_damage(strength, global_position)

func update_hitbox_offset() -> void:
	var distance: float = absf(hitbox_offset.x)
	
	if absf(last_direction.x) > absf(last_direction.y):
		if last_direction.x > 0:
			hitbox.position = Vector2(distance, 0)
			hitbox.rotation_degrees = 0
		else:
			hitbox.position = Vector2(-distance, 0)
			hitbox.rotation_degrees = 180
	else:
		if last_direction.y < 0:
			hitbox.position = Vector2(0, -distance)
			hitbox.rotation_degrees = 270
		elif last_direction.y > 0:
			hitbox.position = Vector2(0, distance)
			hitbox.rotation_degrees = 90

func upgrade_to_lv2() -> void:
	anim_lv1.visible = false
	anim_lv2.visible = true
	current_anim = anim_lv2
	strength = 40
	# เล่นเสียงเลเวลอัพ/เปลี่ยนชุด
	AudioManager.play_sfx("Lvlup")

#----------------------------------------------------
# ระบบรับดาเมจ เลือด และตาย
#----------------------------------------------------
func take_damage(amount: int) -> void:
	if not alive or is_hurt:
		return
	if damage_cooldown.time_left > 0:
		return
		
	if strength == 40: 
		amount = int(amount / 2.0) 
		
	health -= amount
	PlayerStats.health = health
	emit_signal("health_changed", health) 
	
	if health <= 0:
		die()
	else:
		is_hurt = true
		velocity = Vector2.ZERO
		play_animation("hurt", last_direction)
		damage_cooldown.start()
		
		# เล่นเสียงเจ็บ
		AudioManager.play_sfx("Hurt")
	
func die() -> void:
	alive = false
	is_hurt = false
	is_attacking = false
	velocity = Vector2.ZERO
	
	$CollisionShape2D.set_deferred("disabled", true)
	play_animation("die", last_direction)
	
	# เล่นเสียง Game Over
	AudioManager.play_sfx("GameOver")
	
	await current_anim.animation_finished
	died.emit()
	get_tree().change_scene_to_file("res://Scence/stuff/game_over.tscn")

func _on_animated_lv_1_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
	if is_hurt:
		is_hurt = false
		velocity = Vector2.ZERO 

func _on_animated_lv_2_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
	if is_hurt:
		is_hurt = false
		velocity = Vector2.ZERO
		
func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health
		
	PlayerStats.health = health 
	health_changed.emit(health)
