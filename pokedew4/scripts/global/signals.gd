extends Node

signal defeat
signal ten_minutes_passed
signal one_hour_passed
#connects to main state machine
signal switch_state

signal switch_battle_state

signal change_hotbar
signal set_equipment

signal plant_tree

#adds obstructions when they are instantiated to dictionary in Level
signal add_obstruction
signal remove_obstruction

signal set_player_stat_bars

signal update_inventory

signal add_message
signal display_messages
signal messages_done

#connects buffs with Battle for leech seed, etc
signal heal_opponent

#transmits new pokemon from grass container to battle start node 
signal wild_pokemon_appears

signal battle_started

signal switch_in_opponent
signal switch_in_player

#used for when actions are selected by the player in battle. signals to between turns.
signal action_selected

#connects to stat boxes on the stat screen, emits pokemon
signal set_stats


#connects main menu state to main menu  
signal get_main_menu_selection
signal open_sub_menu

#connects to menu manager/menu state machine
signal switch_menu_state

#connects pkmn options state to pokeon options on the pokeslots
signal select_poke_option

#connected in poke_slot, connects poke options menu state to poke panel
signal poke_option_movement
signal close_poke_options
signal choose_poke_option
signal show_stat_screen
signal switch_in_pkmn

#toggles substate in menu state machine
signal toggle_substate

#tells tilemap to replace tilled wet soil with dry soil
signal dry_plot_and_crop

signal change_next_attack

signal set_instruction
signal close_instruction

signal send_notice

#changes display on pkmn stat screen 
signal change_stat_mode

signal open_poke_panel_in_inv

#used to restore functionality to the main meny when a submenu is closed
signal release_menu


signal change_weather

#for placeable items
signal attempt_placement

#used to null previewing in the hotbar after placing an object so it doesnt get deleted
signal null_preview

#connects pokeball effect to battle state machine
signal pokemon_caught

signal request_fire
signal request_water
signal request_electric
signal request_ice
signal request_psi

#emitted when new pokemon is summoned, switching the previous follower to stay
signal new_follower

#emitted from state machine to fieldmon, parameters are fieldmon, station
signal assign_fieldmon
