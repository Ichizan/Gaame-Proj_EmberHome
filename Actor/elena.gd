extends CharacterBody2D

@export var current_village: String = "ruin"
@export var npc_id: String
@export var npc_name: String

@onready var interact_prompt: Label = $Node2D/NewInteract
@onready var dialogue_system: CanvasLayer = $"../DialogueSystem"

var player_node: Node2D = null

func _ready() -> void:
	_update_icons()

func _update_icons() -> void:
	if interact_prompt:
		if current_village == "ruin" and not GameManager.has_talked_in_ruin:
			interact_prompt.visible = true
		elif current_village == "heal" and not GameManager.has_lv2_suit:
			interact_prompt.visible = true
		else:
			interact_prompt.visible = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.name == "playerlv1":
		player_node = body

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.name == "playerlv1":
		player_node = null

func _process(delta: float) -> void:
	if player_node != null and Input.is_action_just_pressed("interact") and not dialogue_system.is_dialogue_active:
		start_elena_dialogue()

func start_elena_dialogue() -> void:
	if dialogue_system == null:
		return
		
	if current_village == "ruin":
		if GameManager.has_talked_in_ruin:
			return 
			
		GameManager.has_talked_in_ruin = true 
		interact_prompt.visible = false 
		
		# 1. ผู้เล่นถามเปิด
		dialogue_system.start_dialogue(GameManager.player_name, ["What happened, Elena?"])
		await dialogue_system.dialogue_finished
		
		# 2. Elena ตอบเหตุการณ์
		dialogue_system.start_dialogue("Elena", [
			GameManager.player_name + ", this is terrible! Our village has just been attacked by Temnota, the Demon of Darkness!",
			"It used its dark powers to take control of the Orcs and sent them to ravage our village."
		])
		await dialogue_system.dialogue_finished
		
		# 3. ผู้เล่นถามถึงชาวบ้าน
		dialogue_system.start_dialogue(GameManager.player_name, ["What about the villagers?"])
		await dialogue_system.dialogue_finished
		
		# 4. Elena เล่าต่อและขอร้อง
		dialogue_system.start_dialogue("Elena", [
			"Many of our people have been killed, while countless others have fled.",
			"You’re our only hope now, " + GameManager.player_name + ". Please, fight the Orcs under its control and drive them away. Protect our people and keep the village safe.",
			"I’ll gather those who remain and search for the missing villagers. Together, we’ll rebuild our home.",
			"May the Light guide your path."
		])
		await dialogue_system.dialogue_finished
		
		# 5. ผู้เล่นตอบรับ
		dialogue_system.start_dialogue(GameManager.player_name, ["May the Light guide your path."])
		await dialogue_system.dialogue_finished
			
		# อัปเดตเควสหลังคุยจบทั้งหมด
		GameManager.is_quest_active = true
		GameManager.quest_updated.emit()
			
	elif current_village == "heal":
		if GameManager.has_lv2_suit:
			return
			
		interact_prompt.visible = false 
		
		# 1. ผู้เล่นทักทายตอนกลับมา
		dialogue_system.start_dialogue(GameManager.player_name, ["I'm back, Elena."])
		await dialogue_system.dialogue_finished
		
		# 2. Elena ขอบคุณ
		dialogue_system.start_dialogue("Elena", [
			"Thank you so much for saving our village, " + GameManager.player_name + "!"
		])
		await dialogue_system.dialogue_finished
		
		# 3. ผู้เล่นถามเรื่องหมู่บ้าน
		dialogue_system.start_dialogue(GameManager.player_name, ["Is the village fully restored?"])
		await dialogue_system.dialogue_finished
		
		# 4. Elena ตอบและมอบของ
		dialogue_system.start_dialogue("Elena", [
			"Yes, we managed to help the survivors and successfully rebuild our home.",
			"As a token of our gratitude...",
			"Please take this Level 2 Armor. You will need it to enter the Temnota Cave!",
			"May the Light guide your path, " + GameManager.player_name + "."
		])
		await dialogue_system.dialogue_finished
		
		# 5. ผู้เล่นบอกลา
		dialogue_system.start_dialogue(GameManager.player_name, ["May the Light guide your path, Elena."])
		await dialogue_system.dialogue_finished
			
		# ปลดล็อกชุดเกราะและร่างผู้เล่น
		GameManager.unlock_level_2()
		if player_node and player_node.has_method("upgrade_to_lv2"):
			player_node.upgrade_to_lv2()
