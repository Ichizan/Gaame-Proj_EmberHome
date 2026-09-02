extends CharacterBody2D

var is_hurt: bool = false
var last_dir: String = "down"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# เริ่มเกมมายืนนิ่งๆ
	_play_anim("idle")

func take_damage(damage: int, attacker_position: Vector2) -> void:
	# ถ้ากำลังเล่นท่าเจ็บอยู่ ให้รอจนกว่าจะจบ (กันท่าเจ็บเล่นซ้ำรัวๆ)
	if is_hurt:
		return
		
	is_hurt = true
	
	# คำนวณทิศทางเพื่อหันหน้าไปหาผู้เล่นตอนโดนตี
	var direction_to_attacker = (attacker_position - position).normalized()
	_update_direction(direction_to_attacker) 
	
	# เล่นท่าเจ็บ
	_play_anim("hurt")
	
	# รอให้ท่าเจ็บเล่นจบ (ถ้าแอนิเมชันยาวกว่านี้ สามารถปรับตัวเลข 0.5 ได้ครับ)
	await get_tree().create_timer(0.5).timeout
	
	# พอกลับมาเป็นปกติ ก็สั่งให้ยืนหายใจนิ่งๆ (idle) ต่อไป
	is_hurt = false
	_play_anim("idle")

# ----------------------------------------------------
# ฟังก์ชันหันหน้าและแอนิเมชัน
# ----------------------------------------------------
func _update_direction(dir: Vector2) -> void:
	if absf(dir.x) > absf(dir.y):
		last_dir = "right" if dir.x > 0 else "left"
	else:
		last_dir = "down" if dir.y > 0 else "up"

func _play_anim(action: String) -> void:
	animated_sprite_2d.play(action + "_" + last_dir)
