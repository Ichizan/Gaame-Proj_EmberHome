extends Node2D

@onready var health_bar: Sprite2D = $Health
@onready var default_width = health_bar.region_rect.size.x
@onready var default_height = health_bar.region_rect.size.y

var max_health: float = 100.0 # ตั้งค่าเริ่มต้นไว้ที่ 100 สำหรับ Orcs

# ฟังก์ชันรับค่าขีดจำกัดเลือดจากบอส
func set_max_health(max_hp: int) -> void:
	max_health = float(max_hp)

func update_health(new_health: int) -> void:
	# เปลี่ยนจากหาร 100.0 เป็นหารด้วย max_health เพื่อหาเปอร์เซ็นต์ที่ถูกต้อง
	var new_width = (float(new_health) / max_health) * default_width
	health_bar.region_rect = Rect2(0, 0, new_width, default_height)
