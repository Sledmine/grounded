(global boolean started true)
(global boolean clua_boolean1 false)
(global short clua_short1 0)
(global short clua_short2 0)
(global short clua_short3 0)
(global string clua_string1 blank)
(global short credits 40) ;sets a global called "credits". It's how the player buys stuff.
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
(global boolean device_open false)
(global short act1_landed 0)
(global boolean human_ally true)
(global boolean sentinel_ally true)
(global short unit_health 0)
(global boolean cameraFunc false)
(global short speedyboi 0)
(global short patterson 0)

(script static unit player0					;this defines "player0" as a unit. This literally just saves time scripting by referencing (player0) instead of (unit (list_get (players) 0))
    (unit (list_get (players) 0))
)

(script static void cameraFunction
	(set cameraFunc true)
)

(script static void cameraControl
	(camera_control 0)
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


;this section is a conversation
(script static void conversation_off
	(set conversation false)
)
;here is fast travel
(script static void ft_capital
	(set clua_string1 "ft_capital")
)

(script static void ft_bar
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 30)
	(if (not (= 6 (structure_bsp_index)))
		(switch_bsp 6)
	)
	(sleep 20)
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
	(sleep 20)
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
	(sleep 20)
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

(script continuous ambient_ai_bsp
	(if (and (= (structure_bsp_index) 2) (= encounter_spawned_bsp3 0))
		(begin
		(begin_random
			(begin ;LEDGE Jackal & Core Elite
				(if (= (ai_living_count g_enc_bsp3struc2) 0)
				(begin
				(ai_place g_enc_bsp3struc2/sqd_jackal_ledge)
				(ai_place g_enc_bsp3struc2/sqd_elite_core)
				(set encounter_spawned_bsp3 1)
				)
				(sleep 10)
				)
			)
			(begin ;Hunters only
				(if (= (ai_living_count g_enc_bsp3struc2) 0)
				(begin
				(ai_place g_enc_bsp3struc2/sqd_hunter)
				(set encounter_spawned_bsp3 1)
				)
				(sleep 10)
				)
			)
			(begin ;all core units
				(if (= (ai_living_count g_enc_bsp3struc2) 0)
				(begin
				(ai_place g_enc_bsp3struc2/sqd_jackal_core)
				(ai_place g_enc_bsp3struc2/sqd_elite_core)
				(ai_place g_enc_bsp3struc2/sqd_grunt_core)
				(set encounter_spawned_bsp3 1)
				)
				(sleep 10)
				)
			)
			(begin ;hunters and jackal ridge
				(if (= (ai_living_count g_enc_bsp3struc2) 0)
				(begin
				(ai_place g_enc_bsp3struc2/sqd_hunter)
				(ai_place g_enc_bsp3struc2/sqd_jackal_ridge)
				(ai_place g_enc_bsp3struc2/sqd_jackal_ledge)
				(set encounter_spawned_bsp3 1)
				)
				(sleep 10)
				)
			)
			(begin ;jackal ledge, grunt ledge, elite ridge, jackal ridge
				(if (= (ai_living_count g_enc_bsp3struc2) 0)
				(begin
				(ai_place g_enc_bsp3struc2/sqd_jackal_ledge)
				(ai_place g_enc_bsp3struc2/sqd_jackal_ridge)
				(ai_place g_enc_bsp3struc2/sqd_elite_ridge)
				(ai_place g_enc_bsp3struc2/sqd_grunt_ledge)
				(set encounter_spawned_bsp3 1)
				)
				(sleep 10)
				)
			)
		)
		)
	)
	(if (not (= (structure_bsp_index) 2))
		(set encounter_spawned_bsp3 0)
	)
)

(SCRIPT startup ambience
	(set cheat_deathless_player 1)
	(ai_attach barman bsp2_bar)
	(ai_attach merchant_1 bsp2_bar/weapons)
	(ai_attach merchant_2 bsp2_bar/weapons)
	(ai_attach surv1 enc_pod1/sqd_marine)
	(ai_attach surv2 enc_pod1/sqd_marine)
	(ai_attach surv3 enc_pod1/sqd_crewman)
	(ai_attach surv4 enc_pod1/sqd_crewman)
	(ai_place bsp2_guard)
	(ai_allegiance "player" "sentinel")
	(ai_allegiance "player" "human")
	(sleep 10)
	(ai_place g_enc_bsp2bar)
	(ai_place g_enc_bsp1raiderCave)
	(act1_landing)
	;================= Predict Sounds =======================
	(sound_impulse_predict sound\dialog\npc_generic\generic true)
	(sound_impulse_predict sound\dialog\lt_patterson\con1_line1 true)
	(sound_impulse_predict sound\dialog\lt_patterson\con1_line2 true)
)

