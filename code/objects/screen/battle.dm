/image/battle
	plane = SCREEN_LAYER
	layer = BATTLE_LAYER+0.1

/image/battle/backlight
	plane = SCREEN_LAYER-1
	layer = BATTLE_BACKGROUND_LAYER

/image/battle/entity
	layer = BATTLE_LAYER+0.2

/image/battle/entity/trainer
	layer = BATTLE_LAYER+0.3

/image/battle/entity/trainer/opponent
	layer = BATTLE_LAYER-0.3

/obj/screen/battle_icon
	screen_loc = "CENTER"
	layer = BATTLE_LAYER
	var/data/battle_data/player/battle

/obj/screen/battle_icon/New(var/data/battle_data/_battle)
	battle = _battle
