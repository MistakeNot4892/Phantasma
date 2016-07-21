
/data/battle_data/player/proc/animate_backlights()
	set waitfor=0
	set background=1
	sleep(8)
	animate(minion_backlight, alpha=255, time = 5)
	animate(opponent_backlight, alpha=255, time = 5)

/data/battle_data/player/proc/animate_trainer_intro(var/data/battle_data/target)
	set waitfor=0
	set background=1
	if(!target)
		return
	sleep(15)
	if(!target)
		return
	var/image/target_img = trainer_images["\ref[target]"]
	if(!target_img)
		return


	var/start_x
	var/end_x
	var/target_x = target_img.pixel_x

	if(target in opponents)
		start_x = target_x-600
		end_x =   target_x+400
	else
		start_x = target_x+600
		end_x =   target_x-400

	target_img.pixel_x = start_x
	target_img.alpha = 255

	animate(target_img, pixel_x = target_x, easing = SINE_EASING|EASE_OUT, time = 15)
	sleep(20)
	animate(target_img, pixel_x = end_x, easing = SINE_EASING|EASE_OUT, time = 15)
	if(target != src)
		owner.notify("\The [target.owner] sent out \the [target.minion.name]!")
	reveal_minion(target)

/data/battle_data/player/proc/animate_minion_intro(var/data/battle_data/target)
	set waitfor=0
	set background=1
	if(!target)
		return
	sleep(15)
	if(!target)
		return
	var/image/target_img = minion_images["\ref[target]"]
	if(!target_img)
		return

	var/target_x = target_img.pixel_x
	target_img.alpha = 255
	target_img.pixel_x = (target in opponents) ? -600 : 420
	animate(target_img, pixel_x = target_x, easing = SINE_EASING|EASE_OUT, time = 15)

/data/battle_data/player/do_intro_animation()
	// Animate the backlights.
	animate_backlights()
	// Trainers/minions appear.
	for(var/data/battle_data/opponent in opponents)
		if(opponent.wild_mob)
			animate_minion_intro(opponent)
		else
			animate_trainer_intro(opponent)
	for(var/data/battle_data/ally in allies)
		if(ally.wild_mob)
			animate_minion_intro(ally)
		else
			animate_trainer_intro(ally)

	// Make the health bars appear.
	sleep(10)
	for(var/obj/O in hp_objects)
		animate(O, alpha = 255, time = 5)
	sleep(5)
	. = ..()

/data/battle_data/player/do_tech_animations(var/data/technique/tech, var/data/battle_data/user, var/data/battle_data/target)

	if(user in allies)
		tech.do_user_rear_anim(minion_images["\ref[user]"])
	else
		tech.do_user_front_anim(minion_images["\ref[user]"])

	if(target in allies)
		tech.do_target_rear_anim(minion_images["\ref[target]"])
	else
		tech.do_target_front_anim(minion_images["\ref[target]"])

	tech.do_battlefield_animation(src)