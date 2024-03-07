extends Node

signal start_game_signal

#Phase of the game
@onready var game_phase = GamePhase.new()

#Game Variables
var round_index = -1
var round_card_number = [7,8,9,10,11,11,12,13]
var new_scene : PackedScene = load("res://Scenes/CardZone/card_zone.tscn")

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
	
	sort_cards_for_run(selected_cards)


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
		for card in cards:
			if card.card.number == 2:
				run_cnt += 1
			elif run_suit == null:
				run_suit = card.card.suit
				run_cnt += 1
			elif run_suit == card.card.suit:
				run_cnt += 1
			elif run_suit != card.card.suit:
				return false
		
		sort_cards_for_run(cards)
		for card in cards:
			print(card.card)
			
		#Check if they have a valid run
		if meld_type == MELD_TYPE.RUN and run_cnt >= 4:
			return true
		elif meld_type == MELD_TYPE.RUN_OF_7 and run_cnt >= 7:
			return true

	return false


#Sort Array for Run
func _compare_cards(a, b) -> bool:
	return a.card.number < b.card.number


func sort_cards_for_run(current_array : Array) -> Array:
	var new_array : Array = []
	var cards = current_array
	#Sort them by number using compare cards
	cards.sort_custom(_compare_cards)
	#Get indexes for two's and aces
	var two_array = []
	var ace_array = []
	for index in range(cards.size()-1):
		if cards[index].card.number == 2:
			two_array.append(cards.pop_at(index))
		if cards[index].card.number == 1:
			ace_array.append(cards.pop_at(index))
	print("No 2's should exist: ")


	#Loop through the array, and move the index of a two if the previous card has a gap
	var previous_num = null
	var nIndex = 0
	for card in cards:
		if previous_num == null:
			pass
		elif previous_num != card.card.number-1 and two_array.size() > 0:
			new_array.append(two_array.pop_front())
			
		new_array.append(card)
		previous_num = card.card.number
		nIndex+=1
	for c in new_array:
		print(c.card)
		
	return new_array
