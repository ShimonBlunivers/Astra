class_name Quest

static var number_of_quests = 0

var active := false
var id : int
var title : String
var description : String
var goal : Goal

func _init(_title : String, _description : String, _goal : Goal):
    id = number_of_quests
    number_of_quests += 1
    title = _title
    description = _description
    goal = _goal
