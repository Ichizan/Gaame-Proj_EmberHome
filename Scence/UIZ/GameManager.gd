extends Node

signal quest_updated

# ตัวแปรระบบ Save/Load และตำแหน่ง
const SAVE_PATH = "user://savegame.save"
var current_map: String = ""
var is_loading_from_save: bool = false 
var player_name: String = "Edgar" 

# ตัวแปรจดจำสถานะผู้เล่นตอนเซฟ
var player_pos_x: float = 0.0
var player_pos_y: float = 0.0
var player_health: int = 100

# ตัวแปรระบบสนทนา
var is_intro_played: bool = false
var has_talked_in_ruin: bool = false
var has_talked_in_heal: bool = false
var has_talked_to_lumi_ruin: bool = false
var has_talked_to_lumi_heal: bool = false
var is_in_dialogue: bool = false 

# ตัวแปรระบบเควสและมอนสเตอร์
var is_quest_active: bool = false
var orcs_killed: int = 0
var target_orcs: int = 10 
var dead_orcs: Array = [] 

# ตัวแปรสถานะความคืบหน้าของเกม
var is_village_healed: bool = false
var has_lv2_suit: bool = false
var is_boss_unlocked: bool = false

# ตัวแปรสำหรับจดจำคัตซีน
var is_mist_intro_played: bool = false
var is_temnota_intro_played: bool = false
var is_heal_intro_played: bool = false # +++ ตัวแปรใหม่ที่ลืมใส่ +++

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file != null:
		var data = {
			"player_name": player_name,
			"is_intro_played": is_intro_played,
			"has_talked_in_ruin": has_talked_in_ruin,
			"has_talked_in_heal": has_talked_in_heal,
			"has_talked_to_lumi_ruin": has_talked_to_lumi_ruin,
			"has_talked_to_lumi_heal": has_talked_to_lumi_heal,
			"is_quest_active": is_quest_active,
			"orcs_killed": orcs_killed,
			"is_village_healed": is_village_healed,
			"has_lv2_suit": has_lv2_suit,
			"is_boss_unlocked": is_boss_unlocked,
			"player_pos_x": player_pos_x,
			"player_pos_y": player_pos_y,
			"player_health": player_health,
			"dead_orcs": dead_orcs,
			"is_mist_intro_played": is_mist_intro_played,
			"is_temnota_intro_played": is_temnota_intro_played,
			"is_heal_intro_played": is_heal_intro_played # +++ บันทึกสถานะเข้าหมู่บ้าน +++
		}
		file.store_var(data)
		file.close() 

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file != null:
			var data = file.get_var()
			file.close()
			
			player_name = data.get("player_name", "Edgar") 
			is_intro_played = data.get("is_intro_played", false)
			has_talked_in_ruin = data.get("has_talked_in_ruin", false)
			has_talked_in_heal = data.get("has_talked_in_heal", false)
			has_talked_to_lumi_ruin = data.get("has_talked_to_lumi_ruin", false)
			has_talked_to_lumi_heal = data.get("has_talked_to_lumi_heal", false)
			is_quest_active = data.get("is_quest_active", false)
			orcs_killed = data.get("orcs_killed", 0)
			is_village_healed = data.get("is_village_healed", false)
			has_lv2_suit = data.get("has_lv2_suit", false)
			is_boss_unlocked = data.get("is_boss_unlocked", false)
			
			player_pos_x = data.get("player_pos_x", 0.0)
			player_pos_y = data.get("player_pos_y", 0.0)
			player_health = data.get("player_health", 100)
			dead_orcs = data.get("dead_orcs", [])
			
			is_mist_intro_played = data.get("is_mist_intro_played", false)
			is_temnota_intro_played = data.get("is_temnota_intro_played", false)
			is_heal_intro_played = data.get("is_heal_intro_played", false) # +++ โหลดสถานะเข้าหมู่บ้าน +++

func add_orc_kill() -> void:
	if is_quest_active:
		orcs_killed += 1
		if orcs_killed >= target_orcs and not is_village_healed:
			is_village_healed = true
			AudioManager.play_sfx("questsuccess")
		quest_updated.emit() 

func unlock_level_2() -> void:
	has_lv2_suit = true
	is_boss_unlocked = true
	quest_updated.emit() 

func reset_game() -> void:
	player_name = "Edgar" 
	orcs_killed = 0
	is_quest_active = false
	is_village_healed = false
	has_lv2_suit = false
	is_boss_unlocked = false
	dead_orcs.clear() 
	
	is_intro_played = false
	has_talked_in_ruin = false 
	has_talked_in_heal = false
	has_talked_to_lumi_ruin = false
	has_talked_to_lumi_heal = false
	
	is_mist_intro_played = false
	is_temnota_intro_played = false
	is_heal_intro_played = false # +++ รีเซ็ตสถานะเข้าหมู่บ้าน +++
	
	player_pos_x = 0.0
	player_pos_y = 0.0
	player_health = 100
	is_loading_from_save = false
