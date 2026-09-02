extends Area2D

const SPEED: float = 250.0
const DAMAGE: int = 20
# ตรวจสอบ Path ของไฟล์หัวใจให้ตรงกับโฟลเดอร์ในโปรเจกต์ของคุณ
const HEALTH_PICKUP = preload("res://Scence/stuff/health_pickup.tscn") 

var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# สั่งให้ลูกไฟพุ่งไปข้างหน้าตามทิศทางที่รับมาจากบอส
	position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	# 1. ถ้าชนบอสตัวเอง ให้ข้ามไป (ไม่ทำอะไร)
	if body.name == "temnotaa" or body.name == "Temnotaa" or body.name == "Temnota":
		return
		
	# 2. ถ้าชนผู้เล่น ทำดาเมจ 20 แล้วทำลายลูกไฟทิ้ง
	if body.name == "playerlv1":
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE)
		queue_free()
	else:
		# 3. ถ้าชนอย่างอื่น (เช่น กำแพง TileMap) ให้ดรอปหัวใจแล้วทำลายลูกไฟทิ้ง
		var pickup = HEALTH_PICKUP.instantiate()
		pickup.global_position = global_position
		get_parent().call_deferred("add_child", pickup) # ใช้ call_deferred เพื่อป้องกัน Error ตอนสร้างของพร้อมกับจังหวะชน
		queue_free()
