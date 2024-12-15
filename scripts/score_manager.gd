extends Node
class_name Scoremanager



var spree = Spree.new()

var huevo_golpeado = false
var huevo_golpeado_ultimo_segundo = false

var max_combo_time = 0
var second_max_combo_time = 0

var puntos_por_cuca = 100
var multip_cuca_melee = 4

export var last_kill_time = -100
var first_killtime_in_spree = -100

var score = 0

var time_passed = 0
var combo_time = 3

var combo_level = 0  # de 0 a 5

var segundos_combo_total = 0


var kills_durante_combo = 0



var required_time_combo_1 = 0
var required_time_combo_2 = 1
var required_time_combo_3 = 4
var required_time_combo_4 = 6
var required_time_combo_5 = 8


var required_kills_combo_1 = 0
var required_kills_combo_2 = 2
var required_kills_combo_3 = 4
var required_kills_combo_4 = 6
var required_kills_combo_5 = 10


func calculate_combo_level(time_in_combo: float) -> int:

	if time_in_combo < required_time_combo_2 or kills_durante_combo < required_kills_combo_2:
		return 1

	elif time_in_combo < required_time_combo_3 or kills_durante_combo < required_kills_combo_3:
		return 2

	elif time_in_combo < required_time_combo_4 or kills_durante_combo < required_kills_combo_4:
		return 3

	elif time_in_combo < required_time_combo_5 or kills_durante_combo < required_kills_combo_5:
		return 4

	elif time_in_combo < 20.0:
		return 5

	else:
		return 5


func get_score():
	return score

func set_score(value):
	score = value

func get_combo_level() -> int:
	update_combo_level_based_on_combo()
	return combo_level
func reset_combo_level():
	combo_level = 0
func set_combo_level(value):
	combo_level = value
func increase_combo_level():
	if combo_level < 5:
		combo_level += 1
func decrease_combo_level():
	if combo_level > 0:
		combo_level -= 1




func select_combo_level_based_on_time() -> int:
	if in_combo():
		combo_level = calculate_combo_level(calculate_time_in_spree(time_passed))
		return combo_level
	else: 
		lose_combo()
		return combo_level



func add_score(points:int):
	score += points


func matar_cuca_wallriding():
	matar_cuca(0, 3)

func matar_cuca_en_aire():
	matar_cuca(0, 2)

func calculate_time(delta):
	time_passed += delta
	

func cuca_muerta_mira_este_player(player):
	

	if player.is_wallruning():
		matar_cuca_wallriding()
		
	elif not player.is_on_floor():
		matar_cuca_en_aire()
		
	else:
	
		matar_cuca()




func matar_cuca(extra_base = 0, extra_combo = 0):
	
	add_score(
		(puntos_por_cuca + 25*time_passed + extra_base) * 
		(2 + combo() + extra_combo) 
		)
	

	
	update_last_time_killed()
	kills_durante_combo += 1


func combo():
	return 3 * combo_time_in_spree()
	


func combo_time_in_spree():

	if in_combo():
		return (calculate_time_in_spree(time_passed))
	else:
		return 0 
	
func calculate_time_in_spree(passed_time: float):
		return spree.calculate_time_in_spree(passed_time)



func update_last_time_killed():
	
	if in_combo():
		# si se updatea pero no lo perdió, se añade el combo al total
		# y se sube de nivel de combo tal vez
		save_combo_time_to_total()
		increase_combo_level()
	else: #no estabas en combo, entonces consigues el primer nivel
		
		# seleccionamos nueva primera kill
		first_killtime_in_spree = time_passed
		
		# primer nivel de combo (el 0 es )
		set_combo_level(2)
	
	last_kill_time = time_passed

func lose_combo():
	kills_durante_combo = 0
	reset_combo_level()
	
func update_max_combo():

	if max_combo_time >= 100:
		max_combo_time = 0
	
	max_combo_time = max((time_passed - first_killtime_in_spree), max_combo_time)


func save_combo_time_to_total():
	segundos_combo_total += time_passed - last_kill_time
	


func in_combo() -> bool:
	
	if (time_passed - last_kill_time) < combo_time:
		return true 
	else:
		return false

func update_combo_level_based_on_combo():
	
	
	if !in_combo():
		lose_combo()


func segundos_en_combo():
	if in_combo():
		return time_passed - last_kill_time
	return 0
	


func golpear_huevo():
	huevo_golpeado = true
	if time_passed >= 19.0:
		score *= 6
		huevo_golpeado_ultimo_segundo = true
	else:
		score *= 3





