extends Node2D

@onready var dialogue_system = $DialogueSystem

func _ready() -> void:
	# หน่วงเวลาเล็กน้อยให้ฉากโหลดเสร็จสมบูรณ์ก่อนเริ่มรันบทสนทนา
	await get_tree().create_timer(0.3).timeout
	
	# กำหนดประโยคเล่าเรื่องในฉากนี้ (สามารถนำตัวแปร GameManager.player_name มาแทรกได้)
	var story_lines = [
		"The day has finally come...",
		"So... this is Temnota Cave...",
		"I’ll defeat you with my blade, Temnota.",
		"I’m ready."
		
	]
	
	# ส่งชื่อผู้บรรยาย และชุดประโยคเข้าไปรัน
	dialogue_system.start_dialogue(GameManager.player_name, story_lines)
	
	# รอจนกว่าผู้เล่นจะกดคลิกอ่านบทสนทนาจนจบประโยคสุดท้าย
	await dialogue_system.dialogue_finished
	GameManager.is_temnota_intro_played = true
	GameManager.save_game()
	
	# เข้าสู่ห้องบอสของจริง
	get_tree().change_scene_to_file("res://Scence/Temnota.tscn") 
