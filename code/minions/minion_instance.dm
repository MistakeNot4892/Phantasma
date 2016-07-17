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
