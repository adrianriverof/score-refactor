extends Node
class_name Spree






var first_killtime_in_spree = -100
var max_combo_time = 0




func calculate_time_in_spree(passed_time: float):
	return (passed_time - first_killtime_in_spree)




func update_max_combo(passed_time):

	if max_combo_time >= 100:
		max_combo_time = 0
	
	max_combo_time = max((passed_time - first_killtime_in_spree), max_combo_time)


func start(passed_time):
	first_killtime_in_spree = passed_time

func lose_combo():
	max_combo_time = 0

