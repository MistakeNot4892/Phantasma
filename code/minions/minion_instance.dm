/minion
	var/name
	var/level = 1
	var/list/data = list()
	var/minion_template/template
	var/mob/trainer/owner
	var/list/techs = list()
	var/list/tech_uses = list()
	var/list/modifiers = list()
	var/status = 0 //bitfield

/minion/New(var/minion_path, var/mob/trainer/_owner)
	if(_owner != null)
		owner = _owner
	template = get_minion_data_by_path(minion_path)
	name = template.name
	for(var/tech in template.techs)
		var/technique/T = get_tech_by_path(tech)
		techs += T
		tech_uses[T.name] = T.max_uses

	data = template.data.Copy()
	data[MD_CHP] = data[MD_MHP]
	data[MD_LVL] = 1
	data[MD_EXP] = 0

/minion/proc/get_turn_speed()
	return data[MD_SPEED]

/minion/proc/get_turn_speed_variance()
	return rand(data[MD_SPEED_VAR_MIN],data[MD_SPEED_VAR_MAX])

/minion/proc/restore()
	data[MD_CHP] = data[MD_MHP]
	status = 0
	for(var/technique/T in techs)
		tech_uses[T.name] = T.max_uses

/minion/proc/get_type_weakness(var/damtype)
	return template.get_type_weakness(damtype)

/minion/proc/get_type_strength(var/damtype)
	return template.get_type_strength(damtype)

/minion/proc/get_same_type_attack_bonus(var/damtype)
	return template.get_same_type_attack_bonus(damtype)

/minion/proc/get_misc_damage_mods()
	return 1