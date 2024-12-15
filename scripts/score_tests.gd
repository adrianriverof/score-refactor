extends GutTest


var ScoreManager = load("res://scripts/score_manager.gd")


func test_ok(): 
	assert_true(true)
	

func test_theres_scoremanager():
	var sut = ScoreManager.new()
	
	assert_not_null(sut)

func test_en_combo_cuando_acabamos_de_matar():
	
	var sut = ScoreManager.new()
	
	sut.matar_cuca()
	
	
	assert_eq(sut.in_combo(), true )


func test_last_kill():
	var sut = ScoreManager.new()
	
	sut.time_passed = 12 
	sut.matar_cuca()
	
	assert_eq(sut.last_kill_time, 12 )


func test_last_kill_is_updated():
	var sut = ScoreManager.new()
	
	sut.time_passed = 12 
	sut.matar_cuca()
	sut.time_passed = 24 
	sut.matar_cuca()
	
	assert_eq(sut.last_kill_time, 24 )



func test_fuera_de_combo_cuando_hace_1000s_que_matamos():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed = 1000
	
	assert_eq(sut.in_combo(), false )

func test_fuera_de_combo_cuando_pasa_mas_del_combotime():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 24
	sut.matar_cuca()
	sut.time_passed += sut.combo_time + 0.1
	
	
	assert_eq(sut.in_combo(), false )

func test_dentro_de_combo_cuando_no_pasa_mas_del_combotime():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 24
	sut.matar_cuca()
	sut.time_passed += sut.combo_time - 0.1
	
	
	assert_eq(sut.in_combo(), true )
	
	
func test_segundos_en_combo_son_los_segundos_que_llevamos_sin_perderlo():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	var tiempoquepasa = sut.combo_time - 0.1
	sut.time_passed += tiempoquepasa #pasa tiempo sin perderlo
	
	assert_eq(sut.segundos_en_combo(), tiempoquepasa )

func test_segundos_en_combo_son_0_si_lo_perdemos():
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += sut.combo_time + 0.1 # perdemos combo
	
	assert_eq(sut.segundos_en_combo(), 0 )

#func test_matar_cuca_

func test_segundos_en_combo_no_acumula_tiempo():
	# solo mide el tiempo desde la ultima muerte
	
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	
	assert_eq(sut.segundos_en_combo(), 1 )

func test_segundos_totales_en_combo_acumula_segundos_en_combo():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca() ##  !!! pero tiene que matar otra para que se updatee
	
	assert_eq(sut.segundos_combo_total, 3 )

func OFFtest_combo_time_total_guarda_el_tiempo_incluyendo_los_ultimos_segundos():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 3
	
	assert_eq(sut.segundos_combo_total, (2+sut.combo_time) )

func test_cuando_puntua_combo_utiliza_acumulado_racha():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	# llevamos 3 segundos en combo
	
	assert_eq(sut.combo(), (3*3) )

func test_cuando_puntua_combo_utiliza_acumulado_racha2():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	
	# llevamos 2 segundos en combo
	
	assert_eq(sut.combo(), (3*2) )

func test_combo_utiliza_la_ultwima_racha_no_acumulado_total():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	# llevamos 3 segundos en combo
	# pero perdemos la racha
	sut.time_passed += 1000
	sut.matar_cuca()
	sut.time_passed += 1
	# aquí llevamos 1s en racha
	
	assert_eq(sut.combo(), (3*1) )

func test_combo_no_suma_nada_si_no_esta_en_racha():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1000
	sut.matar_cuca()
	
	assert_eq(sut.combo(), (0) )


func test_combo_level_increases_when_killing_in_combo_2():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	
	assert_eq(sut.get_combo_level(), (2) )

func test_combo_level_increases_when_killing_in_combo_3():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	
	assert_eq(sut.get_combo_level(), (3) )

func test_combo_level_reset_when_loses_combo():
	var sut = ScoreManager.new()
	
	sut.time_passed = 0
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 3000
	
	assert_eq(sut.get_combo_level(),(0))

func test_when_cuca_killed_that_time_is_lastime_killed():
	var sut = ScoreManager.new()
	
	sut.time_passed = 15
	sut.matar_cuca()
	sut.time_passed += 1
	
	assert_eq(sut.last_kill_time,(15))
	
func test_max_combo_shows_max_combo():
	var sut = ScoreManager.new()
	
	sut.update_max_combo()
	sut.matar_cuca()
	sut.time_passed = 15
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.matar_cuca()
	sut.time_passed += 1
	sut.update_max_combo()
	
	assert_eq(sut.max_combo_time,(3))
	





