extends Node2D

@onready var dialogue_system = $DialogueSystem
@onready var player = $playerlv1 
@onready var hud = $HUD 
@onready var btn_map: Button = $CanvasLayer/btnMap
@onready var map_select: CanvasLayer = $MapSelect

func _ready() -> void:
	# เล่นเพลงของด่าน Ruin Village
	AudioManager.play_bgm("ruin_village")
	
	GameManager.current_map = "village"
	
	if player and hud:
		hud.set_player(player)
		
	# ถ้ายังไม่เคยเล่นบทนำ ให้โชว์ข้อความ
	if not GameManager.is_intro_played:
		GameManager.is_intro_played = true
		dialogue_system.start_dialogue(GameManager.player_name, [
			"What happened here...?",
			"The whole village... It’s been completely destroyed!",
			"Lumi! Where are you? Are you safe?"
		])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# ถ้ายังไม่ได้รับเควส ให้ซ่อนปุ่ม Map ไปเลย (ปุ่มจะโผล่มาพร้อมกรอบเควส)
	if GameManager.is_quest_active:
		btn_map.visible = true
	else:
		btn_map.visible = false
		
	# (เผื่อไว้) ถ้ามีบทสนทนาอื่นอีก ให้ล็อกปุ่มเป็นสีเทา
	if GameManager.is_in_dialogue:
		btn_map.disabled = true
	else:
		btn_map.disabled = false

func _on_btn_exit_pressed() -> void:
	# เล่นเสียงกดปุ่ม
	AudioManager.play_sfx("BTN")
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
	
func _on_btn_map_pressed() -> void:
	# เล่นเสียงกดปุ่ม
	AudioManager.play_sfx("BTN")
	map_select.visible = true # สั่งเปิดหน้าต่าง Map
	get_tree().paused = true
