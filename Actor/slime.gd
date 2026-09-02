extends CharacterBody2D

@export var current_village: String = "ruin"

@onready var interact_prompt: Label = $Node2D/NewInteract
@onready var save_icon: Sprite2D = $Node2D/SaveIcon
@onready var dialogue_system: CanvasLayer = $"../DialogueSystem"

var player_node: Node2D = null
var is_waiting_for_save: bool = false

func _ready() -> void:
	_update_icons()

func _update_icons() -> void:
	interact_prompt.visible = false
	save_icon.visible = false
	
	if current_village == "ruin":
		if GameManager.has_talked_in_ruin and not GameManager.has_talked_to_lumi_ruin:
			interact_prompt.visible = true
		elif GameManager.has_talked_to_lumi_ruin:
			save_icon.visible = true
	elif current_village == "heal":
		if not GameManager.has_talked_to_lumi_heal:
			interact_prompt.visible = true
		else:
			save_icon.visible = true

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.name == "playerlv1":
		player_node = body

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.name == "playerlv1":
		player_node = null
		is_waiting_for_save = false 

func _process(delta: float) -> void:
	if is_waiting_for_save:
		if not dialogue_system.is_dialogue_active:
			is_waiting_for_save = false
			return
			
		if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER):
			is_waiting_for_save = false
			
			if player_node:
				if player_node.has_method("heal"):
					player_node.heal(player_node.max_health) 
				
				GameManager.player_pos_x = player_node.global_position.x
				GameManager.player_pos_y = player_node.global_position.y
				GameManager.player_health = player_node.health
			
			GameManager.save_game() 
			
			dialogue_system.start_dialogue("Lumi", ["Game saved and health restored successfully!"])
		return

	if player_node != null and Input.is_action_just_pressed("interact") and not dialogue_system.is_dialogue_active:
		start_lumi_dialogue()

func start_lumi_dialogue() -> void:
	if dialogue_system == null:
		return
		
	if current_village == "ruin":
		if not GameManager.has_talked_in_ruin:
			return 
			
		if not GameManager.has_talked_to_lumi_ruin:
			GameManager.has_talked_to_lumi_ruin = true
			_update_icons()
			
			dialogue_system.start_dialogue(GameManager.player_name, ["Lumi! Are you safe?!"])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue("Lumi", ["Yes! Elena saved me. Are you safe too?"])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue(GameManager.player_name, ["I'm safe! I need to go hunt those Orcs now. See you later!"])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue("Lumi", ["Good luck! I believe in you."])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue("System", ["You can save your game by talking to Lumi."])
			await dialogue_system.dialogue_finished
			
		else:
			dialogue_system.start_dialogue("Lumi", ["Would you like to save your progress and restore your health?", "(Press Enter to confirm or E to cancel)"])
			is_waiting_for_save = true
			
	elif current_village == "heal":
		if not GameManager.has_talked_to_lumi_heal:
			GameManager.has_talked_to_lumi_heal = true
			_update_icons()
			
			dialogue_system.start_dialogue("Lumi", ["You did it, didn't you?!"])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue(GameManager.player_name, ["Yes, I did it."])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue("Lumi", ["I knew you could do it! See? Our home is back to normal."])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue(GameManager.player_name, ["Yeah! Wait here for now, I have things to do. See you!"])
			await dialogue_system.dialogue_finished
			
			dialogue_system.start_dialogue("Lumi", ["Good luck!"])
			await dialogue_system.dialogue_finished
			
		else:
			dialogue_system.start_dialogue("Lumi", ["Would you like to save your progress and restore your health?", "(Press Enter to confirm or E to cancel)"])
			is_waiting_for_save = true
