extends Node2D


@onready var player = $playerlv1 
@onready var hud = $HUD 

func _ready() -> void:
	if player and hud:
		hud.set_player(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



	


func _on_btn_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scence/menu.tscn")


func _on_btn_ready_pressed() -> void:
	AudioManager.stop_bgm()
	# เปลี่ยน "res://ruin_village.tscn" เป็นชื่อไฟล์ฉากต่อไปของคุณให้ถูกต้อง
	get_tree().change_scene_to_file("res://Scence/UIZ/naming_scene.tscn")
