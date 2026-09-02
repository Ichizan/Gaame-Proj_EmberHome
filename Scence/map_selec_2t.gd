extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_village_pressed() -> void:
	get_tree().change_scene_to_file("res://Scence/heal_village.tscn")


func _on_btn_mist_pressed() -> void:
	get_tree().change_scene_to_file("res://Scence/mist_for.tscn")


func _on_btnfin_pressed() -> void:
	get_tree().change_scene_to_file("res://Scence/Temnota.tscn")
