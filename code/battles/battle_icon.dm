/image/battle
	plane = 10
	layer = 24

/obj/battle_icon
	icon = 'icons/screen/battle_underlay.dmi'
	screen_loc = "CENTER"
	plane = 9
	layer = 23

/obj/battle_icon/New()
	return

/obj/battle_icon/background
	name = "\improper FIGHT!"
	screen_loc = "CENTER"
	icon_state = "square"
	alpha = 0

/obj/battle_icon/background/New()
	var/matrix/M = matrix()
	M.Scale(25)
	transform = M

/obj/battle_icon/overlay
	var/image/sprite
	mouse_opacity = 0

/obj/battle_icon/overlay/New(var/image/_sprite)
	sprite = _sprite
	overlays += sprite
