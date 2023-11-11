class_name Rules_Manager

var rules_array = []
var current_rule = 0

func _init():
	#Load all of the rules from Rules/rules.json  
	var content = null  
	var file = FileAccess.open("res://Rules/rules.json", FileAccess.READ)
	if file != null:
		content = file.get_as_text()
		file.close()
	else:
		print("File does not exist")
		return	
	#Setup rule array
	if content != null:
		var rules = JSON.parse_string(content)
		for rule in rules:
			var new_rule = Rule.new(rule["round"], rule["description"],rule["round_name"],rule["number_of_cards"])
			rules_array.append(new_rule)

func get_current_rule()->String:
	return rules_array[current_rule]["description"]
