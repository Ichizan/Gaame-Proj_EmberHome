extends Node2D

@onready var btn_load: Button = $UI/btnLoad

func _ready() -> void:
	# สั่งเล่นเพลงเมนูโดยเรียกชื่อ Node จาก AudioManager โดยตรง
	AudioManager.play_bgm("Main_at_menu")
	
	if FileAccess.file_exists("user://savegame.save"):
		btn_load.disabled = false
	else:
		btn_load.disabled = true

func _process(delta: float) -> void:
	pass

func _on_btn_start_pressed() -> void:
	# เพิ่มเสียงกดปุ่ม
	AudioManager.play_sfx("BTN")
	
	PlayerStats.reset()
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://Scence/tutorial.tscn")
	
func _on_btn_load_pressed() -> void:
	# เพิ่มเสียงกดปุ่ม
	AudioManager.play_sfx("BTN")
	
	# ปล่อยให้ฉากถัดไปเรียกเพลงใหม่ทับเองได้เลย ไม่ต้องสั่ง stop_bgm() ก็ได้
	GameManager.load_game()
	GameManager.is_loading_from_save = true 
	
	if GameManager.is_village_healed:
		get_tree().change_scene_to_file("res://Scence/heal_village.tscn")
	else:
		get_tree().change_scene_to_file("res://Scence/ruin_village.tscn")

func _on_btn_credit_pressed() -> void:
	# เพิ่มเสียงกดปุ่ม
	AudioManager.play_sfx("BTN")
	
	get_tree().change_scene_to_file("res://Scence/credit.tscn")

# +++ เพิ่มฟังก์ชันสำหรับปุ่ม Options +++
func _on_btn_option_pressed() -> void:
	AudioManager.play_sfx("BTN")
	
	# เรียกใช้ฟังก์ชันเปิด/ปิดเมนูจาก AutoLoad ที่เราสร้างไว้
	if has_node("/root/OptionsMenu"):
		OptionsMenu.toggle_menu()
	else:
		print("หา AutoLoad 'OptionsMenu' ไม่เจอ อย่าลืมไปตั้งค่าใน Project Settings นะครับ")
