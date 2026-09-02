extends CanvasLayer

@onready var bgm_slider: HSlider = $VBoxContainer/BGMSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SFXSlider
@onready var btn_close: Button = $BtnClose

var bgm_bus_index: int
var sfx_bus_index: int

func _ready() -> void:
	visible = false
	
	# ดึง ID ของช่องเสียง BGM และ SFX จาก AudioServer
	bgm_bus_index = AudioServer.get_bus_index("BGM")
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	# ตั้งค่า Slider ให้ตรงกับระดับเสียงปัจจุบันของระบบ
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus_index))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))
	
	# เชื่อมสัญญาณ (Signals)
	bgm_slider.value_changed.connect(_on_bgm_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	btn_close.pressed.connect(_on_close_pressed)

# ระบบกดปุ่ม ESC เพื่อเปิด/ปิดเมนูตั้งค่า
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # ui_cancel คือปุ่ม ESC เริ่มต้นของ Godot
		toggle_menu()

func toggle_menu() -> void:
	visible = !visible
	get_tree().paused = visible # แช่แข็งเกมตอนเปิดเมนู
	
	if visible:
		AudioManager.play_sfx("BTN") # เสียงเปิดเมนู

func _on_bgm_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_volume_db(bgm_bus_index, -80.0) # ปิดเสียงสนิท
	else:
		AudioServer.set_bus_volume_db(bgm_bus_index, linear_to_db(value))

func _on_sfx_changed(value: float) -> void:
	if value == 0:
		AudioServer.set_bus_volume_db(sfx_bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))

func _on_close_pressed() -> void:
	AudioManager.play_sfx("BTN")
	toggle_menu()
