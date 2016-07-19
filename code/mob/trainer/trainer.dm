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
	client.screen += screen_hud
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

/mob/trainer/destroy()
	if(radio)
		qdel(radio)
		radio = null
	if(client)
		if(battle_background)
			client.screen -= battle_background
		client.screen -= screen_hud
		for(var/obj/O in screen_hud)
			qdel(O)
		screen_hud.Cut()
	if(battle_background)
		qdel(battle_background)
		battle_background = null
	last_loc = null
	for(var/minion/M in minions)
		qdel(M)
	minions.Cut()
	for(var/obj/O in contents)
		qdel(O)
	inventory_contents.Cut()
	inventory_data.Cut()
	if(following)
		qdel(following)
		following = null
	return ..()

var/temporary_trainer_count = 100
/mob/trainer/temporary
	name = "figment"

/mob/trainer/temporary/New()
	. = ..()
	name += " #[temporary_trainer_count]"
	temporary_trainer_count++

/mob/trainer/temporary/end_battle()
	density = 0
	spawn(10)
		animate(src,alpha=0,time=5)
	sleep(15)
	qdel(src)