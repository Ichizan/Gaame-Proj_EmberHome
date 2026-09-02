extends Control

@onready var name_input: LineEdit = $LineEdit
@onready var btncon: Button = $btncon 

func _ready() -> void:
	# 1. ล็อคปุ่มไว้ตั้งแต่เริ่มฉาก
	btncon.disabled = true
	
	# เชื่อมสัญญาณปุ่มและกล่องข้อความ
	#btncon.pressed.connect(_on_btncon_pressed)
	name_input.text_submitted.connect(_on_text_submitted)
	
	# 2. เชื่อมสัญญาณ text_changed เพื่อเช็คข้อความแบบเรียลไทม์ตอนกำลังพิมพ์
	name_input.text_changed.connect(_on_text_changed)
	
	name_input.grab_focus()

func _on_text_changed(new_text: String) -> void:
	# ถ้าข้อความว่างเปล่า (หรือมีแต่ช่องว่าง) ให้ล็อคปุ่ม ถ้ามีตัวอักษรให้ปลดล็อค
	if new_text.strip_edges() == "":
		btncon.disabled = true
	else:
		btncon.disabled = false

func _on_btncon_pressed() -> void:
	_save_name_and_start()

func _on_text_submitted(_new_text: String) -> void:
	# ป้องกันการกด Enter โดยที่ยังไม่ได้พิมพ์ชื่อ
	if name_input.text.strip_edges() != "":
		_save_name_and_start()

func _save_name_and_start() -> void:
	var final_name = name_input.text.strip_edges()
	
	GameManager.player_name = final_name
	get_tree().change_scene_to_file("res://Scence/stuff/prologue1.tscn")
