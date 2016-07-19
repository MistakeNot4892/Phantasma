/minion_template/earthbug
	name = "Earthbug"
	icon_state = "earthbug"
	techs = list(
		/technique/healing,
		/technique/combat/earth
	)
	elemental_types = list(DAM_EARTH)
	data = list(
		MD_MHP =   45,
		MD_ATK =   49,
		MD_DEF =   49,
		MD_SPATK = 65,
		MD_SPDEF = 65,
		MD_SPEED = 45
		)

/minion_template/waterfish
	name = "Waterfish"
	icon_state = "waterfish"
	techs = list(
		/technique/healing,
		/technique/combat/water
	)
	elemental_types = list(DAM_WATER)
	data = list(
		MD_MHP =   44,
		MD_ATK =   48,
		MD_DEF =   65,
		MD_SPATK = 50,
		MD_SPDEF = 64,
		MD_SPEED = 43
		)

/minion_template/firelizard
	name = "Firelizard"
	icon_state = "firelizard"
	techs = list(
		/technique/combat,
		/technique/combat/fire
	)
	elemental_types = list(DAM_FIRE)
	data = list(
		MD_MHP =   39,
		MD_ATK =   52,
		MD_DEF =   43,
		MD_SPATK = 60,
		MD_SPDEF = 50,
		MD_SPEED = 65
		)

/minion_template/airbird
	name = "Airbird"
	icon_state = "airbird"
	techs = list(
		/technique/combat,
		/technique/combat/air
	)
	elemental_types = list(DAM_AIR)
	data = list(
		MD_MHP =   35,
		MD_ATK =   55,
		MD_DEF =   30,
		MD_SPATK = 50,
		MD_SPDEF = 40,
		MD_SPEED = 90
		)
