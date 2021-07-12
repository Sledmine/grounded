(global short shipcrash 0) ;sets a global called "shipcrash". I can't remember what I was going to use this for.
(global boolean is_biped_inside_volume false)
(global short credits 40) ;sets a global called "credits". It's how the player buys stuff.
(global boolean merchantboi_1 false) ;this sets merch1 as a global
(global boolean merchantboi_2 false) ;this sets merchantboi_2 as a global
(global boolean conversation false)
(global short have_I_talked 1)
(global short save 0) ;for save slots feature
(global short load 0) ;for save slots feature
(global boolean skull_held false) ;test for deleting the skull from player's hand
(global boolean hover1 false) ;test for journal hovering. Didn't work
(global short unsc_quests 0) ;this global is used to enable speech checks if the player has completed certain unsc sidequests. More side quests = better checks, and certain sidequests unlock unique dialogue


(script static unit player0					;this defines "player0" as a unit. This literally just saves time scripting by referencing (player0) instead of (unit (list_get (players) 0))
    (unit (list_get (players) 0))
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


;this section is a conversation
(script static void forbes_1
	(if (= have_I_talked 1)
		(begin
		(sleep 10)
		(sound_impulse_start "sound\dialog\forbes\f03_caves" forbes 1)	;introduction
		(set have_I_talked 10)
		)
	)
)

(script static void forbes_2
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f04_excellent" forbes 1) ;player accepts mission
)

(script static void forbes_3
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f05_heavylosses" forbes 1) ;player initially rejects
)

(script static void forbes_4
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f06_angryfine" forbes 1) ;player absolutely rejects
)

(script static void forbes_5
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f07_heavyloss" forbes 1) ;question 1
)

(script static void forbes_6
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f08_hog" forbes 1) ;question 2
)

(script static void forbes_7
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f09_recon" forbes 1) ;question 3
)

(script static void forbes_8
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f10_greet" forbes 1) ;player accepts mission
)

(script static void forbes_9
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f11_suspicious" forbes 1) ;player accepts mission
)

(script static void forbes_10
	(sleep 10)
	(sound_impulse_start "sound\dialog\forbes\f12_relief" forbes 1) ;player accepts mission
)

;here is fast travel
(script static void ft_capital
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 40)
	(object_teleport (player0) ft_capital)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)

(script static void ft_bar
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 40)
	(object_teleport (player0) ft_bar)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)

(script static void ft_oni
	(player_enable_input 0)
	(fade_out 0 0 0 30)
	(sleep 40)
	(object_teleport (player0) ft_oni)
	(player_enable_input 1)
	(fade_in 0 0 0 30)
)

(script static void overcharged_shields
	(unit_set_maximum_vitality (player0) 50 150)	;boolean1 health boolean2 shields
)

(script static void conversation_on				;this script is called upon whenever a conversation window is opened. Typically used to disable hud-help-text and provide a cleaner experience.
	(set conversation true)
)

(script static void conversation_off			;this script is called upon whenever a specific widget is clicked on. It sets "conversation" to false.
	(set conversation false)
	(set have_I_talked 1)
)

(script static void hardened_layers
	(unit_set_maximum_vitality (player0) 150 50)	;boolean1 health boolean2 shields
)

(script static void hover_active_1
	(set hover1 true)
	(print blarg)
)

(script static void alien_kit
	(object_create_anew merchant_reset)														;this script forces the player to hold a skull weapon, then empties their inventory
	(object_teleport merchant_reset weapons_merch)											;and forces a new inventory onto them.
	(player_add_equipment (player0) unarmed 1)
	(sleep 2)
	(player_add_equipment (player0) alien 1)
	(set skull_held true)
)

(script static void bust-up 														;gives player bust-up kit
		(object_create_anew merchant_reset)														;this script forces the player to hold a skull weapon, then empties their inventory
		(object_teleport merchant_reset weapons_merch)											;and forces a new inventory onto them.
		(player_add_equipment (player0) unarmed 1)
		(sleep 2)
		(player_add_equipment (player0) bust-up 1)
		(set skull_held true)
)

(script static void ranger
	(object_create_anew merchant_reset)														;this script forces the player to hold a skull weapon, then empties their inventory
	(object_teleport merchant_reset weapons_merch)											;and forces a new inventory onto them.
	(player_add_equipment (player0) unarmed 1)
	(sleep 2)
	(player_add_equipment (player0) ranger 1)
	(set skull_held true)
)

(script static void crewman_1
	(sound_impulse_start sound\dialog\npc_generic\generic barman 1)
)

(SCRIPT startup ambience
	(switch_bsp 1)
	(ai_attach barman bsp2_bar)
	(ai_attach merchant_1 bsp2_bar/weapons)
	(ai_attach merchant_2 bsp2_bar/weapons)
	(sound_impulse_predict sound\dialog\npc_generic\generic 1)
	(ai_place bsp2_guard)
	(sleep 10)
	(vehicle_load_magic hog_guard "w-gunner" (ai_actors bsp2_guard/sqd_scorp))
)

