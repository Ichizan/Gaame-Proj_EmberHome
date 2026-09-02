extends Node2D

@onready var dialogue_system = $DialogueSystem

func _ready() -> void:
	# หน่วงเวลาเล็กน้อยให้ฉากโหลดเสร็จสมบูรณ์ก่อนเริ่มรันบทสนทนา
	await get_tree().create_timer(0.3).timeout
	
	# กำหนดประโยคเล่าเรื่องในฉากนี้ (สามารถนำตัวแปร GameManager.player_name มาแทรกได้)
	var story_lines = [
		"When he returned, he found his village in ruins.",
		"Many of the homes had been reduced to rubble, some nothing more than piles of ash.",
		"Yet, he did not lose hope...",
		"Instead, something inside him began to burn.",
		"A flame of hope...."
	]
	
	# ส่งชื่อผู้บรรยาย และชุดประโยคเข้าไปรัน
	dialogue_system.start_dialogue("", story_lines)
	
	# รอจนกว่าผู้เล่นจะกดคลิกอ่านบทสนทนาจนจบประโยคสุดท้าย
	await dialogue_system.dialogue_finished
	
	# เมื่อจบทั้งหมด ให้สลับไปหน้าคัตซีนถัดไป (เช่น prologue2.tscn)
	get_tree().change_scene_to_file("res://Scence/ruin_village.tscn")
