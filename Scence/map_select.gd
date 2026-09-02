extends CanvasLayer

@onready var btn_ruin: Button = $Control/btnruin
@onready var btn_heal: Button = $Control/btnheal
@onready var btn_mist: Button = $Control/btnMist
@onready var btn_tem: Button = $Control/btntem
@onready var dialogue_system: CanvasLayer = $DialogueSystem

var is_waiting_for_boss_confirm: bool = false

func _process(delta: float) -> void:
	# --- ระบบสลับปุ่มหมู่บ้าน ---
	if GameManager.is_village_healed:
		btn_ruin.visible = false
		btn_heal.visible = true
	else:
		btn_ruin.visible = true
		btn_heal.visible = false
		
	# --- ระบบล็อคปุ่มด่านที่กำลังยืนอยู่ ---
	btn_ruin.disabled = (GameManager.current_map == "village")
	btn_heal.disabled = (GameManager.current_map == "village")
	btn_mist.disabled = (GameManager.current_map == "mist")
	btn_tem.disabled = (GameManager.current_map == "boss" or GameManager.current_map == "FinalCave")

	# --- ระบบรอรับคำสั่งยืนยันเข้าห้องบอส ---
	if is_waiting_for_boss_confirm:
		if not dialogue_system.is_dialogue_active or Input.is_action_just_pressed("interact") or Input.is_key_pressed(KEY_E):
			is_waiting_for_boss_confirm = false
			return
			
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER):
			is_waiting_for_boss_confirm = false
			_enter_temnota()

# โค้ดปุ่มเข้าหมู่บ้านพัง
func _on_btnruin_pressed() -> void:
	AudioManager.play_sfx("BTN")
	AudioManager.stop_bgm()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scence/ruin_village.tscn")

# โค้ดปุ่มเข้าหมู่บ้านฟื้นฟู
func _on_btnheal_pressed() -> void:
	AudioManager.play_sfx("BTN")
	AudioManager.stop_bgm()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scence/heal_village.tscn")

func _on_btn_mist_pressed() -> void:
	AudioManager.play_sfx("BTN")
	AudioManager.stop_bgm()
	get_tree().paused = false
	if not GameManager.is_mist_intro_played:
		get_tree().change_scene_to_file("res://Scence/stuff/Mistprologue.tscn") 
	else:
		get_tree().change_scene_to_file("res://Scence/mist_for.tscn")

func _on_btntem_pressed() -> void:
	AudioManager.play_sfx("BTN")
	
	if GameManager.has_lv2_suit:
		if dialogue_system:
			var texts = [
				"Once you enter, there is no turning back until Temnota is defeated.",
				"(Press Enter to proceed or E to cancel)"
			]
			dialogue_system.start_dialogue("System", texts)
			is_waiting_for_boss_confirm = true
	else:
		if dialogue_system:
			dialogue_system.start_dialogue(GameManager.player_name, ["I don't think I'm ready to go there yet..."])

func _enter_temnota() -> void:
	AudioManager.stop_bgm()
	get_tree().paused = false
	GameManager.is_in_dialogue = false
	
	if dialogue_system:
		dialogue_system.visible = false
		dialogue_system.is_dialogue_active = false
		
	if not GameManager.is_temnota_intro_played:
		get_tree().change_scene_to_file("res://Scence/stuff/TemnoScene.tscn") 
	else:
		get_tree().change_scene_to_file("res://Scence/Temnota.tscn")

func _on_btnback_pressed() -> void:
	AudioManager.play_sfx("BTN")
	visible = false
	get_tree().paused = false
