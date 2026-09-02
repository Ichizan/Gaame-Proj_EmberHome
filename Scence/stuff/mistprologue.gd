extends Node2D

@onready var dialogue_system = $DialogueSystem

func _ready() -> void:
	# หน่วงเวลาเล็กน้อยให้ฉากโหลดเสร็จสมบูรณ์ก่อนเริ่มรันบทสนทนา
	await get_tree().create_timer(0.3).timeout
	
	# กำหนดประโยคเล่าเรื่องในฉากนี้ (สามารถนำตัวแปร GameManager.player_name มาแทรกได้)
	var story_lines = [
		"So... this is the Mist Forest...",
		"So... this is where the ones who destroyed our village are hiding...",
		"I’ll make sure they pay..."
		
	]
	
	# ส่งชื่อผู้บรรยาย และชุดประโยคเข้าไปรัน
	dialogue_system.start_dialogue(GameManager.player_name, story_lines)
	
	# รอจนกว่าผู้เล่นจะกดคลิกอ่านบทสนทนาจนจบประโยคสุดท้าย
	await dialogue_system.dialogue_finished
	# +++ สั่งให้ GameManager จำว่าดูคัตซีนป่าแล้ว +++
	GameManager.is_mist_intro_played = true
	
	# ถ้าอยากให้ระบบเซฟจำไว้เลย เผื่อผู้เล่นออกเกม ก็เรียกเซฟตรงนี้ได้ครับ
	GameManager.save_game()
	
	# เมื่อจบทั้งหมด ให้สลับไปหน้าคัตซีนถัดไป (เช่น prologue2.tscn)
	get_tree().change_scene_to_file("res://Scence/mist_for.tscn")
