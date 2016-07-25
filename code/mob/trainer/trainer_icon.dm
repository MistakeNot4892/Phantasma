/mob/trainer/update_icon()
	icon_state = null

	var/list/images_to_add = list()
	var/append = ""
	if(sleeping)
		append = "_sleeping"
	else if(sprinting)
		append = "_sprinting"

	images_to_add += image('icons/overworld/humans/human.dmi',"base[append]")
	if(icon_strings[TRAINER_ICON_CLOTHES]) images_to_add += image('icons/overworld/humans/human_clothes.dmi',"[icon_strings[TRAINER_ICON_CLOTHES]][append]")
	if(icon_strings[TRAINER_ICON_EYES])    images_to_add += image('icons/overworld/humans/human_eyes.dmi',   "[icon_strings[TRAINER_ICON_EYES]][append]")
	if(icon_strings[TRAINER_ICON_BEARD])   images_to_add += image('icons/overworld/humans/human_beard.dmi',  "[icon_strings[TRAINER_ICON_BEARD]][append]")
	if(icon_strings[TRAINER_ICON_HAIR])    images_to_add += image('icons/overworld/humans/human_hair.dmi',   "[icon_strings[TRAINER_ICON_HAIR]][append]")
	if(icon_strings[TRAINER_ICON_HAT])     images_to_add += image('icons/overworld/humans/human_hat.dmi',    "[icon_strings[TRAINER_ICON_HAT]][append]")

	overlays.Cut()
	overlays += images_to_add

/mob/trainer/get_battle_image(var/mob/holder, var/frontal)

	var/image/I = ..()
	var/list/images_to_add = list()
	if(frontal)
		I.layer -= 0.3
		images_to_add += image(icon = 'icons/battle/humans/body_front.dmi', icon_state = icon_strings[TRAINER_ICON_BODY])
		images_to_add += image(icon = 'icons/battle/humans/eyes_front.dmi', icon_state = icon_strings[TRAINER_ICON_EYES])
		if(icon_strings[TRAINER_ICON_CLOTHES]) images_to_add += image(icon = 'icons/battle/humans/clothes_front.dmi', icon_state = icon_strings[TRAINER_ICON_CLOTHES])
		if(icon_strings[TRAINER_ICON_BEARD])   images_to_add += image(icon = 'icons/battle/humans/beard_front.dmi',   icon_state = icon_strings[TRAINER_ICON_BEARD])
		if(icon_strings[TRAINER_ICON_HAIR])    images_to_add += image(icon = 'icons/battle/humans/hair_front.dmi',    icon_state = icon_strings[TRAINER_ICON_HAIR])
		if(icon_strings[TRAINER_ICON_HAT])     images_to_add += image(icon = 'icons/battle/humans/hat_front.dmi',     icon_state = icon_strings[TRAINER_ICON_HAT])
	else
		I.layer += 0.3
		images_to_add += image(icon = 'icons/battle/humans/body_rear.dmi', icon_state = icon_strings[TRAINER_ICON_BODY])
		if(icon_strings[TRAINER_ICON_CLOTHES]) images_to_add += image(icon = 'icons/battle/humans/clothes_rear.dmi', icon_state = icon_strings[TRAINER_ICON_CLOTHES])
		if(icon_strings[TRAINER_ICON_BEARD])   images_to_add += image(icon = 'icons/battle/humans/beard_rear.dmi',   icon_state = icon_strings[TRAINER_ICON_BEARD])
		if(icon_strings[TRAINER_ICON_HAIR])    images_to_add += image(icon = 'icons/battle/humans/hair_rear.dmi',    icon_state = icon_strings[TRAINER_ICON_HAIR])
		if(icon_strings[TRAINER_ICON_HAT])     images_to_add += image(icon = 'icons/battle/humans/hat_rear.dmi',     icon_state = icon_strings[TRAINER_ICON_HAT])
	I.overlays += images_to_add
	return I
