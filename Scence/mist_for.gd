extends Node2D

@onready var player = $playerlv1 
@onready var hud = $HUD 
@onready var map_select: CanvasLayer = $MapSelect

func _ready() -> void:
	# เล่นเพลงประจำด่าน Mist Forest
	AudioManager.play_bgm("Mist_for")
	
	if player and hud:
		hud.set_player(player)
	GameManager.current_map = "mist"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_btn_exit_pressed() -> void:
	AudioManager.play_sfx("BTN")
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
	
func _on_btn_map_pressed() -> void:
	AudioManager.play_sfx("BTN")
	map_select.visible = true # สั่งโชว์แผนที่
	get_tree().paused = true # แช่แข็งเกม
