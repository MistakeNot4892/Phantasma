/data/minion
	var/name
	var/mob/trainer/owner
	var/data/minion_template/template
	var/participated_in_last_fight

	var/list/techs = list()
	var/list/tech_uses = list()
	var/list/data = list()
	var/list/modifiers = list()

	var/status = 0

	var/obj/screen/minion_status/status_bar
	var/obj/screen/data_panel/data_panel
	var/obj/screen/statbar/health_bar
	var/obj/screen/statbar/experience/xp_bar
	var/list/technique_panels = list()

/data/minion/New(var/minion_path, var/mob/trainer/_owner)
	if(_owner != null)
		owner = _owner

	template = get_unique_data_by_path(minion_path)
	name = template.name
	for(var/tech in template.techs)
		var/data/technique/T = get_unique_data_by_path(tech)
		techs += T
		tech_uses[T.name] = T.max_uses

	data = template.data.Copy()
	data[MD_CHP] = data[MD_MHP]
	data[MD_EXP] = get_xp_threshold_for(4)
	data[MD_LVL] = 5

	health_bar = new(src)
	xp_bar = new(src)
	status_bar = new(src)

	for(var/data/technique/T in techs)
		var/obj/screen/technique/tech = new /obj/screen/technique(src, T)
		technique_panels += tech

/data/minion/destroy()
	techs.Cut()
	if(owner)
		if(owner.client)
			if(status_bar) owner.client.screen -= status_bar
			if(health_bar) owner.client.screen -= health_bar
			if(xp_bar)     owner.client.screen -= xp_bar
			if(data_panel) owner.client.screen -= data_panel
		owner = null

	template = null
	if(status_bar)
		qdel(status_bar)
		status_bar = null
	if(health_bar)
		qdel(health_bar)
		health_bar = null
	if(xp_bar )
		qdel(xp_bar)
		xp_bar = null
	if(data_panel)
		qdel(data_panel)
		data_panel = null
	return ..()

/data/minion/proc/get_turn_speed()
	return data[MD_SPEED]

/data/minion/proc/get_turn_speed_variance()
	return rand(data[MD_SPEED_VAR_MIN],data[MD_SPEED_VAR_MAX])

/data/minion/proc/restore()
	data[MD_CHP] = data[MD_MHP]
	status = 0
	for(var/data/technique/T in techs)
		tech_uses[T.name] = T.max_uses

/data/minion/proc/get_type_weakness(var/damtype)
	return template.get_type_weakness(damtype)

/data/minion/proc/get_type_strength(var/damtype)
	return template.get_type_strength(damtype)

/data/minion/proc/get_same_type_attack_bonus(var/damtype)
	return template.get_same_type_attack_bonus(damtype)

/data/minion/proc/get_misc_damage_mods()
	return 1

/data/minion/proc/get_info_panel()
	if(!data_panel)
		data_panel = new /obj/screen/data_panel(src)
	data_panel.update()
	return data_panel
