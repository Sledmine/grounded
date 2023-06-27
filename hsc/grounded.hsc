(global boolean started false)
(global boolean clua_boolean1 false)
(global short clua_short1 0)
(global short clua_short2 0)
(global short clua_short3 0) ; Designed for the opening menu
(global boolean merchantboi_1 false) ;this sets merch1 as a global
(global boolean merchantboi_2 false) ;this sets merchantboi_2 as a global
(global boolean conversation false)
(global short have_I_talked 1)
(global short save 0) ;for save slots feature
(global short load 0) ;for save slots feature ;test for deleting the skull from player's hand
(global boolean hover1 false) ;test for journal hovering. Didn't work
(global short unsc_quests 0) ;this global is used to enable speech checks if the player has completed certain unsc sidequests. More side quests = better checks, and certain sidequests unlock unique dialogue
(global short encounter_spawned_bsp3 0)
(global boolean reload_now false)
(global boolean openingmenu false)
(global short act1_landed 0)
(global boolean human_ally true)
(global boolean sentinel_ally true)
(global short unit_health 0)
(global short switchrest 0)
(global short speedyboi 0)
(global short patterson 0)
(global short bsp3_struc1_test 0)
(global short rep_medsupply 0)
(global short republic_status 1)

(script static void newgame
	(set clua_short3 1)
)

(script continuous starting_loop
	(if (= openingmenu false)
		(begin
			(camera_set game_menu1 400)
			(sleep 200)
			(camera_set game_menu2 400)
			(sleep 200)
			(camera_set game_menu3 400)
			(sleep 200)
			(camera_set game_menu4 400)
			(sleep 200)
			(camera_set game_menu5 400)
			(sleep 200)
			(camera_set game_menu6 400)
			(sleep 200)
			(camera_set game_menu7 400)
			(sleep 200)
			(camera_set game_menu8 400)
			(sleep 200)
			(camera_set game_menu9 400)
			(sleep 200)
			(camera_set game_menu10 400)
			(sleep 200)
			(camera_set game_menu11 400)
			(sleep 200)
			(camera_set game_menu 400)
			(sleep 300)
		)
		(sleep_until (= openingmenu false))
	)
)

(script static void continuegame
	(set reload_now true)
)

(script static unit player0					;this defines "player0" as a unit. This literally just saves time scripting by referencing (player0) instead of (unit (list_get (players) 0))
    (unit (list_get (players) 0))
)

(script continuous revive_system
	(if (= (unit_get_health (player0)) 0)
		(set reload_now true)
	)
)

(script static void save_game1
	(set save 1)
	(sleep 1)
	(set save 0)
)
(script static void save_game2
	(set save 2)
	(sleep 1)
	(set save 0)
)
(script static void save_game3
	(set save 3)
	(sleep 1)
	(set save 0)
)
(script static void save_game4
	(set save 4)
	(sleep 1)
	(set save 0)
)
(script static void save_game5
	(set save 5)
	(sleep 1)
	(set save 0)
)
(script static void load_game1
	(set load 1)
	(sleep 1)
	(set load 0)
)
(script static void load_game2
	(set load 2)
	(sleep 1)
	(set load 0)
)
(script static void load_game3
	(set load 3)
	(sleep 1)
	(set load 0)
)
(script static void load_game4
	(set load 4)
	(sleep 1)
	(set load 0)
)
(script static void load_game5
	(set load 5)
	(sleep 1)
	(set load 0)
)

(script static void act1_landing
	(begin
		(sleep_until (= act1_landed 1) 5)
		(activate_nav_point_object default (player0) forbes 0.5)
	)
)

;here is fast travel
(script static void ft_capital
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 6 (structure_bsp_index)))
		(switch_bsp 6)
	)
	(sleep 10)
	(object_teleport (player0) ft_capital)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)

(script static void ft_escapepod
	(player_enable_input 0)
	(object_destroy_containing "cine")
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 0 (structure_bsp_index)))
		(switch_bsp 0)
	)
	(sleep 10)
	(object_teleport (player0) bsp1_spawn)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
	(object_set_scale bsp1door 2 0)
	(object_set_scale bsp2door 2 0)
)


(script static void ft_bar
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 6 (structure_bsp_index)))
		(switch_bsp 6)
	)
	(sleep 10)
	(object_teleport (player0) ft_bar)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)

(script static void ft_oni
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 6 (structure_bsp_index)))
		(switch_bsp 6)
	)
	(sleep 10)
	(object_teleport (player0) ft_oni)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)

(script static void ft_struc1
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 2 (structure_bsp_index)))
		(switch_bsp 2)
	)	
	(sleep 10)
	(object_teleport (player0) ft_struc1)
	(object_teleport ft_hog ft_struc1_hog)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)


(script static void overcharged_shields
	(unit_set_maximum_vitality (player0) 50 150)	;boolean1 health boolean2 shields
)

(script static void hardened_layers
	(unit_set_maximum_vitality (player0) 150 50)	;boolean1 health boolean2 shields
)

(script static void alien_kit
	(object_create_anew merchant_reset)														;this script forces the player to hold a skull weapon, then empties their inventory
	(object_teleport merchant_reset weapons_merch)											;and forces a new inventory onto them.
	(player_add_equipment (player0) unarmed 1)
	(sleep 2)
	(player_add_equipment (player0) alien 1)
)

(script static void bust-up 														;gives player bust-up kit
		(object_create_anew merchant_reset)														;this script forces the player to hold a skull weapon, then empties their inventory
		(object_teleport merchant_reset weapons_merch)											;and forces a new inventory onto them.
		(player_add_equipment (player0) unarmed 1)
		(sleep 2)
		(player_add_equipment (player0) bust-up 1)
)

(script static void ranger
	(object_create_anew merchant_reset)														;this script forces the player to hold a skull weapon, then empties their inventory
	(object_teleport merchant_reset weapons_merch)											;and forces a new inventory onto them.
	(player_add_equipment (player0) unarmed 1)
	(sleep 2)
	(player_add_equipment (player0) ranger 1)
)

(script static void crewman_1
	(sound_impulse_start sound\dialog\npc_generic\generic barman 1)
)

(script startup ambience
	(fade_in 0 0 0 150)
	(sound_looping_start "sound\music\grounded\menu\menu" none 1)
	(set cheat_deathless_player 1)
	(camera_control 1)
	(camera_set game_menu 0)
	(sleep_until (= clua_short3 1) 5)
	(camera_control 0)
	(set started true)
	(set openingmenu true)
	(sound_looping_stop "sound\music\grounded\menu\menu")
	(ai_attach barman bsp2_bar)
	(ai_attach merchant_1 bsp2_bar/weapons)
	(ai_attach merchant_2 bsp2_bar/weapons)
	(ai_attach surv1 enc_pod1/sqd_marine)
	(ai_attach surv2 enc_pod1/sqd_marine)
	(ai_attach surv3 enc_pod1/sqd_crewman)
	(ai_attach surv4 enc_pod1/sqd_crewman)
	(object_create_anew_containing "openworld")
	(object_destroy_containing "cine")
	(ai_place bsp2_guard)
	(ai_allegiance "player" "sentinel")
	(ai_allegiance "player" "human")
	(sleep 10)
	(ai_place g_enc_bsp2bar)
	(ai_place g_enc_bsp1raiderCave)
	(ai_place bsp3_pod1guard)
	(ai_attach raider_michael g_enc_bsp1raiderCave/sqd_human2)
	;(ai_attach elite_guard1 bsp3_pod1guard/sqd_captain)
	(act1_landing)
	;================= Predict Sounds =======================
	(sound_impulse_predict sound\dialog\npc_generic\generic true)
	(sound_impulse_predict sound\dialog\lt_patterson\con1_line1 true)
	(sound_impulse_predict sound\dialog\lt_patterson\con1_line2 true)
)

