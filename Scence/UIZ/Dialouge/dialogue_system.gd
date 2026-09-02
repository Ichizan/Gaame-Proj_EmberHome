extends CanvasLayer

@onready var name_label: Label = $HBoxContainer/VBoxContainer/NameLabel
@onready var text_label: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel

signal dialogue_finished
var tween: Tween
var dialogue_lines: Array = []
var current_line_index: int = 0
var is_dialogue_active: bool = false

func _ready() -> void:
	# ซ่อนกรอบไดอะล็อกไว้ก่อนตอนเริ่มเกม
	visible = false

# ฟังก์ชันนี้รอรับค่า "ชื่อคนพูด" และ "รายการประโยค" จาก NPC
func start_dialogue(npc_name: String, lines: Array) -> void:
	GameManager.is_in_dialogue = true # สั่งแช่แข็งผู้เล่น
	
	name_label.text = npc_name # บรรทัดนี้คือการเอาชื่อ NPC ไปโชว์
	dialogue_lines = lines
	current_line_index = 0
	visible = true
	is_dialogue_active = true
	_show_current_line()
	
	visible = true
	is_dialogue_active = true
	_show_current_line()

func _show_current_line() -> void:
	# ดึงข้อความมาใส่ตรงๆ โดยไม่ต้องแปลงคำว่า {name}
	text_label.text = dialogue_lines[current_line_index]
	
	text_label.visible_ratio = 0.0
	
	if tween:
		tween.kill()
	tween = create_tween()
	
	var duration = text_label.text.length() * 0.03
	tween.tween_property(text_label, "visible_ratio", 1.0, duration)
func _input(event: InputEvent) -> void:
	if not is_dialogue_active:
		return
		
	if event.is_action_pressed("interact") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		# เช็คว่าเปอร์เซ็นต์ยังไม่ถึง 1.0 ใช่ไหม ถ้าใช่ให้โชว์ครบ 100% ทันที
		if text_label.visible_ratio < 1.0:
			if tween:
				tween.kill()
			text_label.visible_ratio = 1.0
		else:
			current_line_index += 1
			if current_line_index < dialogue_lines.size():
				_show_current_line()
			else: # จังหวะที่ประโยคหมดแล้ว
				visible = false
				is_dialogue_active = false
				GameManager.is_in_dialogue = false # ปลดล็อกผู้เล่น
				
				dialogue_finished.emit() # <--- เพิ่มบรรทัดนี้ เพื่อตะโกนบอกว่าคุยจบแล้ว!
