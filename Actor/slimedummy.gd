extends CharacterBody2D

@onready var interact_prompt: Label = $Node2D/NewInteract
@onready var dialogue_system: CanvasLayer = $"../DialogueSystem"

var player_node: Node2D = null

func _ready() -> void:
	if interact_prompt:
		interact_prompt.visible = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.name == "playerlv1":
		player_node = body
		if interact_prompt:
			interact_prompt.visible = true

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.name == "playerlv1":
		player_node = null
		if interact_prompt:
			interact_prompt.visible = false

func _process(_delta: float) -> void:
	# คุยได้เรื่อยๆ เมื่อกดปุ่ม interact (เช่น ปุ่ม E) และไม่ได้อยู่ในบทสนทนา
	if player_node != null and Input.is_action_just_pressed("interact") and not GameManager.is_in_dialogue:
		start_lumi_dialogue()

func start_lumi_dialogue() -> void:
	var texts = [
		"Hello Master, I am Lumi!",
		"I am your beloved pet.",
		"You can save the game by talking to me.",
		"See you later!"
	]
	
	if dialogue_system:
		dialogue_system.start_dialogue("Lumi", texts)
