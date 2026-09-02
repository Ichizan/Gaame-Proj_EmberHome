extends Node2D
@onready var player: CharacterBody2D = $playerlv1
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	# อัปเดตสถานะด่านปัจจุบัน
	if player and hud:
		hud.set_player(player)
	GameManager.current_map = "boss"
	
	# ตอนเริ่มฉาก ให้ซ่อนและปิดประตูกรง (BossDoor) ไว้ก่อน
	for door in get_tree().get_nodes_in_group("boss_doors"):
		door.visible = false
		if door.has_node("CollisionShape2D"):
			door.get_node("CollisionShape2D").set_deferred("disabled", true)


func _on_btn_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
	
