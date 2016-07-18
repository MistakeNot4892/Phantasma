var/list/minion_data_templates = list()
/proc/get_minion_data_by_path(var/minion_path)
	if(!minion_data_templates[minion_path])
		minion_data_templates[minion_path] = new minion_path
	return minion_data_templates[minion_path]

/minion
	var/name
	var/level = 1
	var/list/data = list()
	var/minion_template/template
	var/mob/trainer/owner
	var/list/techs = list()
	var/list/tech_uses = list()
	var/list/battle_modifiers = list()
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

/minion_template
	var/name = "Minion"
	var/icon_state = "minion"
	var/list/techs = list(
		/technique/combat
		)
	var/list/weak_against = list()
	var/list/strong_against = list()
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
