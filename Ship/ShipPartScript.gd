class_name ShipPart extends Node2D


var durability_max: float: 
    get: return durability_max  
    set(value):
        durability_max = value
        durability_current = min(durability_current, durability_max)

var durability_current : float :
    get: return durability_current
    set(value): durability_current = min(value, durability_max)


func _init(durability : float):
    durability_max = durability
    durability_current = durability