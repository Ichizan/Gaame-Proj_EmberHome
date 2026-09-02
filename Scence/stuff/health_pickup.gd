extends Area2D

const HEALTH_EFFECT: int = 20

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "playerlv1":
		# เช็คก่อนว่าตอนนี้เลือดน้อยกว่า max_health (100) ใช่ไหม
		if body.health < body.max_health:
			if body.has_method("heal"):
				body.heal(HEALTH_EFFECT)
				queue_free() # ลบไอเทมทิ้งเฉพาะตอนที่เลือดไม่เต็มและฮีลสำเร็จเท่านั้น
