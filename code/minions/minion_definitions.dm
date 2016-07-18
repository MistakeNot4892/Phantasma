/minion_template/earthbug
	name = "Earthbug"
	icon_state = "earthbug"
	techs = list(
		/technique/healing,
		/technique/combat/earth
	)
	weak_against = list(DAM_AIR)
	strong_against = list(DAM_WATER)

/minion_template/waterfish
	name = "Waterfish"
	icon_state = "waterfish"
	techs = list(
		/technique/healing,
		/technique/combat/water
	)
	weak_against = list(DAM_EARTH)
	strong_against = list(DAM_FIRE)

/minion_template/firelizard
	name = "Firelizard"
	icon_state = "firelizard"
	techs = list(
		/technique/combat,
		/technique/combat/fire
	)
	weak_against = list(DAM_WATER)
	strong_against = list(DAM_AIR)

/minion_template/airbird
	name = "Airbird"
	icon_state = "airbird"
	techs = list(
		/technique/combat,
		/technique/combat/air
	)
	weak_against = list(DAM_FIRE)
	strong_against = list(DAM_EARTH)
