var/list/minion_data_templates = list()
/proc/get_minion_data_by_path(var/minion_path)
	if(!minion_data_templates[minion_path])
		minion_data_templates[minion_path] = new minion_path
	return minion_data_templates[minion_path]

/minion_template
	var/name = "Minion"
	var/icon_state = "minion"
	var/list/techs = list(
		/technique/combat
		)
	var/list/elemental_types = list(DAM_NEUTRAL)
	var/list/data = list(
		MD_MHP =   100,
		MD_ATK =   10,
		MD_DEF =   10,
		MD_SPATK = 10,
		MD_SPDEF = 10,
		MD_SPEED = 10,
		MD_FLEE = 5,
		MD_SPEED_VAR_MIN = 1,
		MD_SPEED_VAR_MAX = 3
		)

/minion_template/proc/get_type_weakness(var/damtype)
	return 1

/minion_template/proc/get_type_strength(var/damtype)
	return 1

/minion_template/proc/get_same_type_attack_bonus(var/damtype)
	if(damtype in elemental_types)
		if(elemental_types.len == 1)
			return 2
		else
			return 1.5
	return 1
