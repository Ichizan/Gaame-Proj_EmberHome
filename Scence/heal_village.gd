extends Node2D

@onready var player = $playerlv1 
@onready var hud = $HUD 
@onready var map_select: CanvasLayer = $MapSelect
@onready var dialogue_system: CanvasLayer = $DialogueSystem # อ้างอิงไปที่โหนดกล่องข้อความ

func _ready() -> void:
	# เล่นเพลงประจำด่าน Heal Village
	AudioManager.play_bgm("heal_village")
	
	GameManager.current_map = "village"
	
	if player and hud:
		hud.set_player(player)
		
	# เช็คว่าเข้าหมู่บ้านที่ฟื้นฟูแล้วเป็นครั้งแรกหรือเปล่า
	if dialogue_system and not GameManager.is_heal_intro_played:
		_play_welcome_back_cutscene()

func _process(delta: float) -> void:
	pass

func _on_btn_exit_pressed() -> void:
	AudioManager.play_sfx("BTN") # เพิ่มเสียงกดปุ่ม
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
	
func _on_btn_map_pressed() -> void:
	# ป้องกันการเปิดแผนที่แทรกตอนกำลังคุยคัตซีน
	if not GameManager.is_in_dialogue:
		AudioManager.play_sfx("BTN") # เพิ่มเสียงกดปุ่ม
		map_select.visible = true 
		get_tree().paused = true 

func _play_welcome_back_cutscene() -> void:
	# ล็อคตัวผู้เล่นไม่ให้เดิน
	GameManager.is_in_dialogue = true
	
	# หน่วงเวลา 0.5 วินาทีให้ภาพฉากโหลดและเฟดเสร็จก่อนค่อยเด้งข้อความ
	await get_tree().create_timer(0.5).timeout
	
	var texts = [
		"My beloved village... it’s finally the way it used to be.",
		"I'm back... my beloved village."
	]
	
	# ดึงชื่อผู้เล่นที่ตั้งไว้มาเป็นคนพูด
	dialogue_system.start_dialogue(GameManager.player_name, texts)
	
	# รอจนกว่าจะกดอ่านจบ
	await dialogue_system.dialogue_finished
	
	# บันทึกสถานะว่าเล่นคัตซีนนี้ไปแล้ว จะได้ไม่เด้งซ้ำตอนเข้ามาใหม่
	GameManager.is_heal_intro_played = true
	GameManager.save_game()
