extends Node
class_name Spree








var first_killtime_in_spree = -100
var max_combo_time = 0




func calculate_time_in_spree(passed_time: float):

	var tiempo = (passed_time - first_killtime_in_spree)

	update_max_combo(passed_time)


	if tiempo > 0:
		return tiempo
	else:
		return 0

		

func update_max_combo(passed_time):

	if max_combo_time >= 100:
		max_combo_time = 0
	
	max_combo_time = max((passed_time - first_killtime_in_spree), max_combo_time)


func start(passed_time):
	first_killtime_in_spree = passed_time



