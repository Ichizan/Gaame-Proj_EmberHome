extends CharacterBody2D

const SPEED: int = 80
const KNOCKBACK_FORCE: int = 150
const ATTACK_RANGE: float = 40.0 

# เช็ค Path ลูกไฟให้ตรงกับโฟลเดอร์ของคุณ
const PROJECTILE_SCENE = preload("res://Scence/stuff/fireball.tscn") 

var is_alive: bool = true
var health: int = 1000 # เลือดบอส
var melee_damage: int = 10 
var target = null

var is_hurt: bool = false
var is_attacking: bool = false
var can_melee: bool = true 
var can_shoot: bool = true 
var last_dir: String = "down"
var unique_id: String = ""

# ตัวแปรคุมคัตซีน
var has_started_fight: bool = false
var has_talked_intro: bool = false
var is_dying: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: Node2D = $HealthBar

func _ready() -> void:
	unique_id = GameManager.current_map + "_" + name
	if GameManager.dead_orcs.has(unique_id):
		queue_free()
		return
		
	if health_bar and health_bar.has_method("set_max_health"):
		health_bar.set_max_health(health)
		
func _physics_process(delta: float) -> void:
	if not is_alive:
		return
		
	# ล็อกบอสให้อยู่นิ่งๆ ตอนกำลังคุย, ยังไม่เริ่มสู้, หรือกำลังจะตาย
	if GameManager.is_in_dialogue or not has_started_fight or is_dying:
		velocity = Vector2.ZERO
		_play_anim("idle")
		move_and_slide()
		return
		
	if is_hurt:
		move_and_slide()
		return
		
	if target:
		var distance = position.distance_to(target.position)
		if distance <= ATTACK_RANGE:
			if not is_attacking and can_melee:
				_do_melee_attack()
		else:
			if not is_attacking:
				if can_shoot:
					_do_shoot_attack()
				else:
					_run_towards_target(delta)
	else:
		if not is_attacking:
			_play_anim("idle")
			velocity = Vector2.ZERO
			
	move_and_slide()

# ----------------------------------------------------
# คัตซีนเปิดตัว และ คัตซีนตอนตาย
# ----------------------------------------------------
func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == "playerlv1" and is_alive:
		target = body
		# คุยเปิดตัวแค่ครั้งแรกครั้งเดียว
		if not has_talked_intro:
			has_talked_intro = true
			start_intro_sequence()

func start_intro_sequence() -> void:
	velocity = Vector2.ZERO
	
	# 1. บอสเริ่มคุย
	var dialogue_system = get_tree().current_scene.get_node_or_null("DialogueSystem")
	if dialogue_system:
		dialogue_system.start_dialogue("Temnota", ["Foolish mortal...", "You dare enter my domain?"])
		await dialogue_system.dialogue_finished
		
		# 2. ผู้เล่นพูดโต้ตอบ
		dialogue_system.start_dialogue(GameManager.player_name, ["Prepare yourself , Temnota!"])
		await dialogue_system.dialogue_finished
		
		# ปลดล็อกสถานะการคุยหลังจากโต้ตอบจบ
		GameManager.is_in_dialogue = false
		dialogue_system.visible = false
		dialogue_system.is_dialogue_active = false
		
	# +++ 3. เริ่มเปิดเพลงสู้บอสตรงนี้ (หลังจากคุยเสร็จ) +++
	AudioManager.play_bgm("Temnofight")
		
	# 4. ปิดประตูขังผู้เล่นหลังคุยจบ
	for door in get_tree().get_nodes_in_group("boss_doors"):
		door.visible = true
		if door.has_node("CollisionShape2D"):
			door.get_node("CollisionShape2D").set_deferred("disabled", false)
			
	# 5. เริ่มสู้ได้!
	has_started_fight = true

func start_death_sequence() -> void:
	is_dying = true
	is_hurt = false
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true) # กันผู้เล่นฟันซ้ำตอนตาย
	
	# +++ หยุดเพลงสู้บอสทันทีที่เลือดหมด ก่อนเริ่มประโยคสั่งเสีย +++
	AudioManager.stop_bgm()
	
	# 1. บอสสั่งเสีย
	var dialogue_system = get_tree().current_scene.get_node_or_null("DialogueSystem")
	if dialogue_system:
		dialogue_system.start_dialogue("Temnota", ["Curse you, " + GameManager.player_name + "...", "The darkness will never truly fade..."])
		await dialogue_system.dialogue_finished
		
		# ปลดล็อกสถานะการคุยทันทีที่บทสนทนาจบลง
		GameManager.is_in_dialogue = false
		dialogue_system.visible = false
		dialogue_system.is_dialogue_active = false
		
	# 2. ข้ามการเล่นอนิเมชันตาย สั่งลบตัวและเปลี่ยนฉากทันที!
	_die_instantly()

# ----------------------------------------------------
# ระบบรับดาเมจ และ โจมตี
# ----------------------------------------------------
func take_damage(damage: int, attacker_position: Vector2) -> void:
	if not is_alive or is_hurt or is_dying:
		return
		
	health -= damage
	if health_bar:
		health_bar.update_health(health) 
	
	var knockback_direction = (position - attacker_position).normalized()
	_update_direction(-knockback_direction) 
	
	if health <= 0:
		start_death_sequence() # ตัดเข้าคัตซีนก่อนตาย
	else:
		is_hurt = true
		_play_anim("hurt")
		
		# +++ เล่นเสียงบอสเจ็บ +++
		AudioManager.play_sfx("BossHurt")
		
		velocity = knockback_direction * KNOCKBACK_FORCE
		
		await get_tree().create_timer(0.3).timeout
		if is_alive and not is_dying:
			is_hurt = false
			velocity = Vector2.ZERO

func _die_instantly() -> void:
	is_alive = false
	velocity = Vector2.ZERO
	
	if not GameManager.dead_orcs.has(unique_id):
		GameManager.dead_orcs.append(unique_id)
		
	# ปลดล็อก Pause เพื่อให้เปลี่ยนฉากได้ชัวร์ๆ
	get_tree().paused = false
	
	# สลับไปคัตซีนสุดท้ายทันทีโดยไม่ต้องรออนิเมชัน
	get_tree().change_scene_to_file("res://Scence/stuff/EndingScene.tscn")

func _run_towards_target(delta: float) -> void:
	var direction = (target.position - position).normalized()
	velocity = direction * SPEED
	_update_direction(direction)
	_play_anim("run")

func _do_melee_attack() -> void:
	is_attacking = true
	can_melee = false 
	velocity = Vector2.ZERO
	
	var direction = (target.position - position).normalized()
	_update_direction(direction)
	_play_anim("attack")
	
	if target and target.has_method("take_damage"):
		target.take_damage(melee_damage)
		var knockback_dir = (target.global_position - global_position).normalized()
		target.velocity = knockback_dir * 250
	
	await get_tree().create_timer(0.6).timeout
	if is_alive and not is_dying:
		is_attacking = false
		await get_tree().create_timer(1.5).timeout
		can_melee = true

func _do_shoot_attack() -> void:
	is_attacking = true
	can_shoot = false
	velocity = Vector2.ZERO
	
	var direction = (target.position - position).normalized()
	_update_direction(direction)
	_play_anim("attack")
	
	var proj = PROJECTILE_SCENE.instantiate()
	proj.global_position = global_position 
	proj.direction = direction 
	get_parent().add_child(proj)
	
	# +++ เล่นเสียงบอสปล่อยลูกไฟ +++
	AudioManager.play_sfx("Fireball")
	
	await get_tree().create_timer(0.6).timeout
	if is_alive and not is_dying:
		is_attacking = false
		
	await get_tree().create_timer(10.0).timeout
	can_shoot = true

# ----------------------------------------------------
# ฟังก์ชันแอนิเมชัน
# ----------------------------------------------------
func _update_direction(dir: Vector2) -> void:
	if absf(dir.x) > absf(dir.y):
		last_dir = "right" if dir.x > 0 else "left"
	else:
		last_dir = "down" if dir.y > 0 else "up"

func _play_anim(action: String) -> void:
	animated_sprite_2d.play(action + "_" + last_dir)

func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == "playerlv1" and is_alive:
		target = null
