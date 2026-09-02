extends Node2D

@onready var dialogue_system = $DialogueSystem

func _ready() -> void:
	# หน่วงเวลาเล็กน้อยให้ฉากโหลดเสร็จสมบูรณ์ก่อนเริ่มรันบทสนทนา
	await get_tree().create_timer(0.3).timeout
	
	# กำหนดประโยคเล่าเรื่องในฉากนี้ (สามารถนำตัวแปร GameManager.player_name มาแทรกได้)
	var story_lines = [
		GameManager.player_name + " was a young boy, born to a warrior and a healer who traveled together as members of an adventuring party.",
		"Because of the lives they led, his parents rarely had much time to spend with him.",
		"To keep him company, they gave him a little slime named Lumi. From that day on, the two of them became inseparable.",
		"His parents also entrusted him to Elena, the village chief, who raised and cared for him as her own... until—",
		"One day, he ventured deep into the forest alone to train and hunt. But when he returned, he found..."
		
	]
	
	# ส่งชื่อผู้บรรยาย และชุดประโยคเข้าไปรัน
	dialogue_system.start_dialogue("", story_lines)
	
	# รอจนกว่าผู้เล่นจะกดคลิกอ่านบทสนทนาจนจบประโยคสุดท้าย
	await dialogue_system.dialogue_finished
	
	# เมื่อจบทั้งหมด ให้สลับไปหน้าคัตซีนถัดไป (เช่น prologue2.tscn)
	get_tree().change_scene_to_file("res://Scence/stuff/prologue2.tscn")
