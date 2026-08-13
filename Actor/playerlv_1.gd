extends CharacterBody2D

#----------------------------------------------------
# การตั้งค่าตัวแปร (Variables Setup)
#----------------------------------------------------
const SPEED = 200.0

var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var hitbox_offset: Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

#----------------------------------------------------
# ทำงานครั้งแรกเมื่อโหลดตัวละคร (Ready)
#----------------------------------------------------
func _ready() -> void:
	# เก็บค่าตำแหน่งดั้งเดิมของ Hitbox ไว้ใช้อ้างอิงระยะห่าง
	hitbox_offset = hitbox.position

#----------------------------------------------------
# วงจรการทำงานหลักของตัวละคร (Physics Process)
# รันทุกๆ เฟรมของระบบฟิสิกส์
#----------------------------------------------------
func _physics_process(delta: float) -> void:
	
	# ตรวจสอบการกดปุ่มโจมตี
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
		
	process_movement()
	process_animation()
	move_and_slide()

#----------------------------------------------------
# ระบบจัดการการเคลื่อนที่ (Movement)
#----------------------------------------------------
func process_movement() -> void:
	# รับค่าการกดปุ่ม 4 ทิศทาง
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		# ล็อกไม่ให้หันหน้า/สลับ Hitbox ระหว่างกำลังโจมตีอยู่ (แต่ตัวยังขยับได้)
		if not is_attacking:
			last_direction = direction
			update_hitbox_offset()
	else:
		velocity = Vector2.ZERO

#----------------------------------------------------
# ระบบเลือกเล่นแอนิเมชันหลัก (Animation Selection)
#----------------------------------------------------
func process_animation() -> void:
	if is_attacking:
		# เช็คว่าถ้ากำลังตีและเดินไปด้วย ให้เล่น run_attack
		if velocity != Vector2.ZERO:
			play_animation("run_attack", last_direction)
		else:
			# ถ้าตีแต่อยู่เฉยๆ ให้เล่น attack ปกติ
			play_animation("attack", last_direction)
		# หยุดทำคำสั่งด้านล่างเพื่อไม่ให้แอนิเมชัน "เดิน" มาแทรกตอนกำลังตี
		return 
		
	if velocity != Vector2.ZERO:
		play_animation("run", last_direction)
	else: 
		play_animation("idle", last_direction)

#----------------------------------------------------
# ระบบคำนวณทิศทางเพื่อเล่นแอนิเมชัน 4 ทิศ (Play Animation 4-Way)
#----------------------------------------------------
func play_animation(prefix: String, dir: Vector2) -> void:
	# ใช้ absf() สำหรับค่า float แทน abs() เพื่อป้องกัน Error
	if absf(dir.x) > absf(dir.y):
		animated_sprite_2d.flip_h = dir.x < 0
		animated_sprite_2d.play(prefix + "_right")
	else:
		animated_sprite_2d.flip_h = false # รีเซ็ตการพลิกภาพ
		if dir.y < 0:
			animated_sprite_2d.play(prefix + "_up")
		elif dir.y > 0:
			animated_sprite_2d.play(prefix + "_down")

#----------------------------------------------------
# ระบบสั่งการโจมตี (Attack)
#----------------------------------------------------
func attack() -> void:
	is_attacking = true
	update_hitbox_offset() # ให้ชัวร์ว่า Hitbox หันถูกทางตอนกดตี

#----------------------------------------------------
# ตรวจสอบเมื่อแอนิเมชันเล่นจบ (Animation Finished Signal)
# *อย่าลืมผูก Signal จาก AnimatedSprite2D มาที่ฟังก์ชันนี้ด้วยนะครับ*
#----------------------------------------------------
func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false

#----------------------------------------------------
# ระบบหมุนและสลับตำแหน่ง Hitbox (Update Hitbox)
#----------------------------------------------------
func update_hitbox_offset() -> void:
	# ระบุ :float และใช้ absf() เพื่อความแม่นยำ
	var distance: float = absf(hitbox_offset.x)
	
	# ใช้ absf() ในการเช็คค่าแนวแกน
	if absf(last_direction.x) > absf(last_direction.y):
		if last_direction.x > 0: # หันขวา
			hitbox.position = Vector2(distance, 0)
			hitbox.rotation_degrees = 0
		else: # หันซ้าย
			hitbox.position = Vector2(-distance, 0)
			hitbox.rotation_degrees = 180
	else:
		if last_direction.y < 0: # หันขึ้น
			hitbox.position = Vector2(0, -distance)
			hitbox.rotation_degrees = 270
		elif last_direction.y > 0: # หันลง
			hitbox.position = Vector2(0, distance)
			hitbox.rotation_degrees = 90
