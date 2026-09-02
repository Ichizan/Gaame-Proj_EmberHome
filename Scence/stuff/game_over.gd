extends Node2D

@onready var btn_load_last: Button = $UI/VBoxContainer/btnLoadLast
@onready var btn_ext: Button = $UI/VBoxContainer/btnEXT

func _ready() -> void:
	# ปลดล็อกเมาส์ให้ขยับมาคลิกปุ่มได้ (เผื่อเมาส์ถูกซ่อนไว้)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# ตรวจสอบไฟล์เซฟ ถ้าไม่เคยเซฟมาก่อนให้ปุ่มสีเทากดไม่ได้
	if not FileAccess.file_exists(GameManager.SAVE_PATH):
		btn_load_last.disabled = true

func _on_btn_load_last_pressed() -> void:
	# 1. โหลดข้อมูลจากไฟล์เซฟ
	GameManager.load_game()
	
	# 2. เปิดสวิตช์บอกระบบว่าเรากำลังโหลดเซฟมา (เพื่อให้ไปเกิดตรงหน้าสไลม์)
	GameManager.is_loading_from_save = true 
	
	# 3. เช็คว่าต้องกลับไปหมู่บ้านแบบไหน (แก้ Path ให้ตรงกับโฟลเดอร์คุณ)
	if GameManager.is_village_healed:
		get_tree().change_scene_to_file("res://Scence/heal_village.tscn")
	else:
		get_tree().change_scene_to_file("res://Scence/ruin_village.tscn")

func _on_btn_ext_pressed() -> void:
	# 1. ล้างข้อมูลเควสและการเล่นทั้งหมดใน GameManager
	GameManager.reset_game()
	
	# 2. ส่งผู้เล่นกลับไปที่หน้า Main Menu
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
