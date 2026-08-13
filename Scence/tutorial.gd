extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	# เปลี่ยน "res://ruin_village.tscn" เป็นชื่อไฟล์ฉากต่อไปของคุณให้ถูกต้อง
	get_tree().change_scene_to_file("res://Scence/ruin_village.tscn")


func _on_btn_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
