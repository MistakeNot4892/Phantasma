/mob/trainer/update_icon()
	overlays = null
	icon_state = null

	var/list/images_to_add = list()
	var/append = ""
	if(sleeping)
		append = "_sleeping"
	else if(sprinting)
		append = "_sprinting"

	images_to_add += image('icons/overworld/humans/human.dmi',"base[append]")
	if(icon_clothes) images_to_add += image('icons/overworld/humans/human_clothes.dmi',"[icon_clothes][append]")
	if(icon_eyes)    images_to_add += image('icons/overworld/humans/human_eyes.dmi',"[icon_eyes][append]")
	if(icon_beard)   images_to_add += image('icons/overworld/humans/human_beard.dmi',"[icon_beard][append]")
	if(icon_hair)    images_to_add += image('icons/overworld/humans/human_hair.dmi',"[icon_hair][append]")
	if(icon_hat)     images_to_add += image('icons/overworld/humans/human_hat.dmi',"[icon_hat][append]")

	overlays += images_to_add

/mob/trainer/get_battle_image(var/mob/holder, var/frontal)

	var/image/I = ..()
	var/list/images_to_add = list()
	if(frontal)
		I.layer -= 0.3
		images_to_add += image(icon = 'icons/battle/humans/body_front.dmi', icon_state = icon_body)
		images_to_add += image(icon = 'icons/battle/humans/eyes_front.dmi', icon_state = icon_eyes)
		if(icon_clothes) images_to_add += image(icon = 'icons/battle/humans/clothes_front.dmi', icon_state = icon_clothes)
		if(icon_beard)   images_to_add += image(icon = 'icons/battle/humans/beard_front.dmi', icon_state = icon_beard)
		if(icon_hair)    images_to_add += image(icon = 'icons/battle/humans/hair_front.dmi', icon_state = icon_hair)
		if(icon_hat)     images_to_add += image(icon = 'icons/battle/humans/hat_front.dmi', icon_state = icon_hat)
	else
		I.layer += 0.3
		images_to_add += image(icon = 'icons/battle/humans/body_rear.dmi', icon_state = icon_body)
		if(icon_clothes) images_to_add += image(icon = 'icons/battle/humans/clothes_rear.dmi', icon_state = icon_clothes)
		if(icon_beard)   images_to_add += image(icon = 'icons/battle/humans/beard_rear.dmi', icon_state = icon_beard)
		if(icon_hair)    images_to_add += image(icon = 'icons/battle/humans/hair_rear.dmi', icon_state = icon_hair)
		if(icon_hat)     images_to_add += image(icon = 'icons/battle/humans/hat_rear.dmi', icon_state = icon_hat)
	I.overlays += images_to_add
	return I
