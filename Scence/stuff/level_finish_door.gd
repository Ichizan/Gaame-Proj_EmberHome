extends Area2D

# เปิดช่องใน Inspector ให้คุณลากไฟล์ Scene (.tscn) ด่านต่อไปมาใส่ได้
@export var next_scene: PackedScene
@export var is_final_level: bool = false  

# ทำงานเมื่อมีวัตถุ (body) เดินเข้ามาชน Area2D นี้
func _on_body_entered(body: Node2D) -> void:
	# เช็คว่าวัตถุที่ชนอยู่ในกลุ่ม "Player" และมีการใส่ฉากด่านต่อไปไว้แล้ว
	# (💡 ทริค: ถ้าคุณไม่ได้ตั้ง Group ไว้ ให้แก้เป็น if body.name == "playerlv_1" and next_scene != null: แทนครับ)
	if body.name == "playerlv_1" and next_scene != null:
		
		# --- ส่วนนี้คือเรื่องเสียง ปิดไว้ก่อนโดยการใส่ # ด้านหน้า ---
		# AudioManager.level_complete_sfx.play()
		# if is_final_level:  
		#     AudioManager.stop_music()  
		
		# เปลี่ยนฉากไปยังด่านต่อไปด้วยคำสั่งพื้นฐานของ Godot
		get_tree().change_scene_to_packed(next_scene)
