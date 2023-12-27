extends Node 
#Card Actions
enum Action { DRAW, PASS, TAKE, REQUEST, DISCARD }
var card_action_string : Array = ["DRAW", "PASS", "TAKE", "REQUEST", "DISCARD"]

func get_action_string(action : Action) -> String:
    return card_action_string[action]