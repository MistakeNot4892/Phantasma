/data/minion_template/earthbug
	name = "Earthsprite"
	icon_state = "earthbug"
	techs = list(
		/data/technique/healing,
		/data/technique/combat/earth
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
	gem_colour = "#8F563B"

/data/minion_template/waterfish
	name = "Kelpice"
	icon_state = "waterfish"
	techs = list(
		/data/technique/healing,
		/data/technique/combat/water
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
	gem_colour = "#306082"

/data/minion_template/firelizard
	name = "Embermote"
	icon_state = "firelizard"
	techs = list(
		/data/technique/combat,
		/data/technique/combat/fire
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
	gem_colour = "#DF7126"

/data/minion_template/airbird
	name = "Skywhit"
	icon_state = "airbird"
	techs = list(
		/data/technique/combat,
		/data/technique/combat/air
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
	gem_colour = "#CBDBFC"
