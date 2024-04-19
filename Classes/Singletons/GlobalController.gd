extends Node

signal start_game_signal

#Phase of the game
@onready var game_phase = GamePhase.new()

#Game Variables
var round_index = -1
var round_card_number = [7,8,9,10,11,11,12,13]
var new_scene : PackedScene = load("res://Scenes/CardZone/card_zone.tscn")
var round_place_conditions = [
	[MELD_TYPE.SET, MELD_TYPE.SET],
	[MELD_TYPE.SET, MELD_TYPE.RUN],
	[MELD_TYPE.RUN, MELD_TYPE.RUN],
	[MELD_TYPE.SET, MELD_TYPE.SET, MELD_TYPE.SET],
	[MELD_TYPE.SET, MELD_TYPE.RUN_OF_7],
	[MELD_TYPE.SET, MELD_TYPE.SET, MELD_TYPE.RUN],
	[MELD_TYPE.SET, MELD_TYPE.RUN, MELD_TYPE.RUN],
	[MELD_TYPE.RUN, MELD_TYPE.RUN, MELD_TYPE.RUN]
]

#Discard Data
var discard_pile : Array = []
var current_discard_card : Card

#Player Pickup Requests
var player_pickup_request : Array[bool] = [false, false, false, false]
var players_picked_up = 0

#Meld Types
enum MELD_TYPE { SET, RUN, RUN_OF_7 }
var meld_type_string : Array = ["Set", "Run", "Run of 7"]

#Send the signal to the GameController and to the UIController to start the game
func start_game():
	emit_signal("start_game_signal")


#Clear the requests in the player pickup array.
func clear_requests():
	player_pickup_request = [false, false, false, false]

#Get meld string
func get_meld_string(meld : MELD_TYPE) -> String:
	return meld_type_string[meld]	

#Validate if the cards selected can equal a meld that is needed
func get_selected_cards():
	var selected_cards = get_tree().get_nodes_in_group("selected")

#Check if a meld is valid
func check_for_meld(cards : Array, meld_type : MELD_TYPE)-> bool:
	#Check if there is a set
	if meld_type == MELD_TYPE.SET:
		var set_num = null
		var set_cnt = 0
		for card in cards:
			if card.card.number == 2:
				set_cnt += 1
			elif set_num == null:
				set_num = card.card.number
				set_cnt += 1
			elif set_num == card.card.number:
				set_cnt += 1
			elif set_num != card.card.number:
				return false
		#Check if they have a valid set
		if set_cnt >= 3:
			return true
	if meld_type == MELD_TYPE.RUN or meld_type == MELD_TYPE.RUN_OF_7:
		var run_suit = null
		var run_cnt = 0
		var current_num = null
		var direction = null
		var offset = 0
		for card in cards:
			
			#If suit does not equal return false
			if run_suit != null and card.card.suit != run_suit and direction != null and card.card.number != 2:
				return false
			#If number does not equal the next number than return false
			elif run_suit != null and card.card.number != null and direction != null and card.card.number != 2:
				#If the current number is a king and the next number is not an ace and we are going up then return false
				if current_num == 13 and card.card.number != 1 and direction == 1:
					return false
				#If the current number is a 2 and the next number is an ace and we are going down then return false
				elif current_num == 2 and card.card.number != 1 and direction == -1:
					return false
				#If the current number is not going in the right direction return false
				elif current_num + direction != card.card.number:
					return false
			elif direction == null and current_num != null and run_suit != null and card.card.number != 2:
				#Identify the direction
				if current_num == 13 and card.card.number == 1:
					direction = 1
				elif card.card.number > current_num:
					direction = 1
				elif card.card.number < current_num:
					direction = -1
				else:
					return false
				#Identify if valid
				if current_num + direction + offset != card.card.number:
					return false
			
			#If two then check direction to update current number
			if card.card.number == 2:
				if direction == 1:
					current_num += 1
				elif direction == -1:
					current_num -= 1
				else:
					offset += 1				
				run_cnt+= 1
			else:
				run_suit = card.card.suit
				current_num = card.card.number
				run_cnt += 1
			
			if run_suit != null:
				print(str(run_suit) + " - " + str(current_num) + " Count = " + str(run_cnt))
		
		
		#Check if they have a valid run
		if meld_type == MELD_TYPE.RUN and run_cnt >= 4:
			return true
		elif meld_type == MELD_TYPE.RUN_OF_7 and run_cnt >= 7:
			return true

	return false

#Validate if all the melds together are valid
func validate_place_conditions():
	var melds_needed = round_place_conditions[round_index]