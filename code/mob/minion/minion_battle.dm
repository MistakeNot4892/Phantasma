/mob/minion/end_battle()
	if(wild)
		density = 0
		spawn(10)
			animate(src,alpha=0,time=5)
		sleep(15)
		qdel(src)

/mob/minion/get_minion()
	return minion_data

/mob/minion/restore()
	minion_data.restore()
