extends CanvasLayer

@onready var dialogue_system = $"../DialogueSystem"
@onready var thank_you_label = $ThankYouLabel
@onready var btn_exit = $btnExit 

func _ready() -> void:
	visible = false
	AudioManager.play_bgm("END")
	GameManager.is_in_dialogue = true
	_play_ending_sequence()

func _play_ending_sequence() -> void:
	await get_tree().create_timer(0.5).timeout
	
	dialogue_system.start_dialogue("Villager", [GameManager.player_name + "! " + GameManager.player_name + "!"])
	await dialogue_system.dialogue_finished
	
	dialogue_system.start_dialogue("Lumi", ["You did great, Master!"])
	await dialogue_system.dialogue_finished
	
	dialogue_system.start_dialogue("Elena", ["Now, it is time to praise our Savior."])
	await dialogue_system.dialogue_finished
	
	dialogue_system.start_dialogue("Everyone", [GameManager.player_name + "!!"])
	await dialogue_system.dialogue_finished
	
	_show_end_hud()

func _show_end_hud() -> void:
	GameManager.is_in_dialogue = false 
	thank_you_label.text = "THANK YOU, " + GameManager.player_name.to_upper()
	visible = true

func _on_btn_exit_pressed() -> void:
	AudioManager.play_sfx("BTN")
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://Scence/menu.tscn")
