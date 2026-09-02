extends CanvasLayer

const HEART_SIZE : int = 20
var player

const HEART_FULL = preload("res://Assets/element/hearts/Heart4_4.png")
const HEART_3_4 = preload("res://Assets/element/hearts/Heart3_4.png")
const HEART_HALF = preload("res://Assets/element/hearts/Heart2_4.png")
const HEART_1_4 = preload("res://Assets/element/hearts/Heart1_4.png")
const HEART_EMPT = preload("res://Assets/element/hearts/Heart0_4.png")

@onready var fade_overlay: ColorRect = $FadeOverlay
@onready var hearts_container: HBoxContainer = $Hearts

# --- เพิ่มตัวแปรสำหรับระบบเควส ---
@onready var quest_box: NinePatchRect = $QuestBox
@onready var quest_label: Label = $QuestBox/QuestLabel

func _ready() -> void:
	# ซ่อนกรอบเควสไว้ก่อนตอนเริ่มเกม และเชื่อมสายสัญญาณ
	if quest_box:
		quest_box.visible = false
		GameManager.quest_updated.connect(_update_quest_ui)
		_update_quest_ui()

func set_player(p) -> void:
	player = p
	if player:
		# อัปเดตเลือดครั้งแรกตอนเริ่มเกม
		_update_health(player.health) 
		# ผูกสายสัญญาณ เลือดลดให้เรียกใช้ฟังก์ชัน
		player.health_changed.connect(_update_health)

func _update_health(new_health: int) -> void:
	var hearts = hearts_container.get_children()
	
	for i in range(hearts.size()):
		# คำนวณเลือดที่เหลือสำหรับหัวใจดวงนี้
		var heart_value = new_health - (i * HEART_SIZE)
		
		if heart_value >= 20:
			hearts[i].texture = HEART_FULL
		elif heart_value >= 15:
			hearts[i].texture = HEART_3_4
		elif heart_value >= 10:
			hearts[i].texture = HEART_HALF
		elif heart_value >= 5:
			hearts[i].texture = HEART_1_4
		else:
			hearts[i].texture = HEART_EMPT

# --- เพิ่มฟังก์ชันอัปเดตเควส ---
func _update_quest_ui() -> void:
	# เช็คความปลอดภัยเผื่อลืมสร้างโหนด
	if not quest_box or not quest_label:
		return
		
	# 1. ถ้าอัปเกรดเกราะแล้ว = เควสจบสมบูรณ์ ให้ซ่อนกรอบถาวร
	if GameManager.has_lv2_suit:
		quest_box.visible = false
		return
		
	# 2. ถ้ายังไม่ได้รับเควสจาก Elena ให้ซ่อนกรอบไว้
	if not GameManager.is_quest_active:
		quest_box.visible = false
		return

	# 3. ถ้ารับเควสแล้ว ให้โชว์กรอบเควสขึ้นมา
	quest_box.visible = true
	
	if GameManager.orcs_killed < GameManager.target_orcs:
		quest_label.text = "Quest: Defeat the Orcs (" + str(GameManager.orcs_killed) + "/" + str(GameManager.target_orcs) + ")"
	else:
		quest_label.text = "Quest Complete! 
							Return to Elena in the village."

func fade(to_alpha:float) -> void:
	var tween:= create_tween()
	tween.tween_property(fade_overlay,"modulate:a", to_alpha, 1.5)
	await tween.finished
