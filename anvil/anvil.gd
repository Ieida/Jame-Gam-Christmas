extends Node3D
class_name Anvil

@export var upgrades: Array[Upgrade]

func buy(candy: Candy) -> PackedScene:
	var upgrades_in_range = get_upgrades_in_price_range(candy.amount)
	if upgrades_in_range.size() == 0:
		return null
		
	var upgrade = upgrades_in_range.pick_random()
	candy.add_amount(-upgrade.price)
	return upgrade.item

func get_upgrades_in_price_range(price: float) -> Array[Upgrade]:
	var upgrds: Array[Upgrade] = []
	for upgrade in upgrades:
		if upgrade.price <= price:
			upgrds.append(upgrade)
	return upgrds
