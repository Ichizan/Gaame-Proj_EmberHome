extends Node

# ตัวแปรจดจำว่าตอนนี้กำลังเล่นเพลง (BGM) โหนดไหนอยู่ จะได้สั่งปิดถูกตัวเมื่อเปลี่ยนด่าน
var current_bgm: AudioStreamPlayer = null

# -------------------------
# ระบบเพลงพื้นหลัง (BGM)
# -------------------------
func play_bgm(bgm_name: String) -> void:
	# ค้นหาโหนดตามชื่อที่ส่งเข้ามา
	var target_bgm = get_node_or_null(bgm_name)
	
	if target_bgm == null:
		print("ไม่พบโหนด BGM: ", bgm_name)
		return
		
	# ถ้าสั่งเล่นเพลงเดิมที่กำลังเล่นอยู่ ให้ข้ามไปเลย (เพลงจะได้ไม่เริ่มใหม่ตอนโหลดกลับมาหน้าเดิม)
	if target_bgm == current_bgm and current_bgm.playing:
		return
		
	# ปิดเพลงเก่าก่อน (ถ้ามี)
	stop_bgm()
	
	# เล่นเพลงใหม่และบันทึกสถานะไว้
	target_bgm.play()
	current_bgm = target_bgm

func stop_bgm() -> void:
	if current_bgm != null:
		current_bgm.stop()
		current_bgm = null

# -------------------------
# ระบบเสียงเอฟเฟกต์ (SFX)
# -------------------------
func play_sfx(sfx_name: String) -> void:
	# ค้นหาโหนดเสียงเอฟเฟกต์ตามชื่อ
	var target_sfx = get_node_or_null(sfx_name)
	
	if target_sfx != null:
		target_sfx.play() # สั่งเล่นเสียงทันที
	else:
		print("ไม่พบโหนด SFX: ", sfx_name)
