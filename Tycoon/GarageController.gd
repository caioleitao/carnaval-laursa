extends Control

@onready var coin_label = $CoinLabel
@onready var btn_stage1 = $BtnStage1
@onready var btn_stage2 = $BtnStage2
@onready var btn_stage3 = $BtnStage3
@onready var btn_social = $BtnSocial

func _ready():
	# Update coin display
	update_coin_display()
	GameManager.coins_updated.connect(_on_coins_updated)
	GameManager.stage_unlocked.connect(_on_stage_unlocked)
	
	# Connect buttons
	btn_stage1.pressed.connect(func(): on_stage_pressed(1, "res://Assets/Scenes/RhythmGame.tscn"))
	btn_stage2.pressed.connect(func(): on_stage_pressed(2, "res://Assets/Scenes/RhythmGame2.tscn"))
	btn_stage3.pressed.connect(func(): on_stage_pressed(3, "res://Assets/Scenes/RhythmGame3.tscn"))
	btn_social.pressed.connect(func(): get_tree().change_scene_to_file("res://Assets/Scenes/SocialMedia.tscn"))
	
	# Update all button visuals
	update_all_buttons()

func update_coin_display():
	coin_label.text = "Coins: " + str(GameManager.coins)

func _on_coins_updated(_val):
	update_coin_display()
	update_all_buttons()

func _on_stage_unlocked(_idx):
	update_all_buttons()

func update_all_buttons():
	update_button_visual(btn_stage1, 1)
	update_button_visual(btn_stage2, 2)
	update_button_visual(btn_stage3, 3)

func update_button_visual(btn: Button, index: int):
	if GameManager.is_stage_unlocked(index):
		btn.text = "Stage " + str(index) + " - PLAY"
		btn.modulate = Color(1, 1, 1)
	else:
		var cost = GameManager.get_stage_cost(index)
		btn.text = "Stage " + str(index) + " - " + str(cost) + " coins"
		if GameManager.coins >= cost:
			btn.modulate = Color(1, 1, 0.5)  # Can afford - yellowish
		else:
			btn.modulate = Color(0.6, 0.6, 0.6)  # Can't afford - dimmed

func on_stage_pressed(index: int, scene_path: String):
	if GameManager.is_stage_unlocked(index):
		get_tree().change_scene_to_file(scene_path)
	else:
		if GameManager.unlock_stage(index):
			print("Stage ", index, " unlocked!")
		else:
			print("Not enough coins to unlock stage ", index)
