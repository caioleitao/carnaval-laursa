# GameManager.gd
extends Node

signal coins_updated(amount)
signal stage_unlocked(stage_index)

var coins: int = 0
var coin_booster: float = 1.0
var unlocked_stages: Dictionary = {
	1: true,
	2: false,
	3: false
}
var stage_costs: Dictionary = {
	1: 0,
	2: 100,
	3: 250
}

func add_coins(amount: int, use_booster: bool = false):
	var final_amount = amount
	if use_booster and amount > 0:
		final_amount = int(amount * coin_booster)
	
	coins = max(0, coins + final_amount)
	coins_updated.emit(coins)
	print("Coins changed: ", final_amount, ". Total: ", coins)

func is_stage_unlocked(stage_index: int) -> bool:
	return unlocked_stages.get(stage_index, false)

func get_stage_cost(stage_index: int) -> int:
	return stage_costs.get(stage_index, 999999)

func unlock_stage(stage_index: int) -> bool:
	if is_stage_unlocked(stage_index):
		return true
		
	var cost = get_stage_cost(stage_index)
	if coins >= cost:
		coins -= cost
		unlocked_stages[stage_index] = true
		coins_updated.emit(coins)
		stage_unlocked.emit(stage_index)
		return true
	
	return false

func _ready():
	# For debugging/testing
	pass
