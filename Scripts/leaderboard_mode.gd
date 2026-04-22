class_name LeaderboardMode

extends Resource

var name: String
var decending_order: bool
var fetch_url: String
var submit_url: String
var local_value_get_function: Callable

func _init(name: String, decending_order: bool, fetch_url: String, submit_url: String, local_value_get_function: Callable):
	self.name = name
	self.decending_order = decending_order
	self.fetch_url = fetch_url
	self.submit_url = submit_url
	self.local_value_get_function = local_value_get_function
