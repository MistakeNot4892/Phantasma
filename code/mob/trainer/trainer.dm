/mob/trainer

	name = "placeholder trainer"
	icon = 'icons/overworld/trainer.dmi'
	icon_state = "trainer"

	var/tmp/obj/battle_icon/background/battle_background
	var/tmp/sleeping = 0
	var/tmp/turf/last_loc

/mob/trainer/New()
	for(var/i=1 to 3)
		minions += new /minion(pick(typesof(/minion_template)-/minion_template), src)
	update_following_minion()

	battle_background = new /obj/battle_icon/background()
	battle_background.mouse_opacity = 0
	battle_background.invisibility = 100
	..()

/mob/trainer/Move()

	if(current_battle)
		return // No moving during fights!

	last_loc = get_turf(src)
	. = ..()
	if(following && loc != last_loc)
		following.Move(last_loc)

/mob/trainer/update_icon()
	overlays = null
	if(sleeping)
		icon_state = "[initial(icon_state)]_sleeping"
		overlays |= "sleeping"
	else if(sprinting)
		icon_state = "[initial(icon_state)]_sprinting"
	else
		icon_state = initial(icon_state)

/mob/trainer/Login()
	. = ..()
	client.screen += battle_background
	if(sleeping)
		visible_message("<b>\The [src] wakes up!</b>")
	density = 1
	sleeping = 0
	icon_state = initial(icon_state)
	update_icon()
	create_hud()

/mob/trainer/Logout()
	. = ..()
	if(current_battle)
		current_battle.dropout(src)
	if(!sleeping)
		visible_message("<b>\The [src]</b> falls asleep...")
	density = 0
	sleeping = 1
	update_icon()
