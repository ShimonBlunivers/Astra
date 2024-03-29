class_name CustomObjectSpawn extends Resource

# TODO

var npc_preset   # [id, nickname, [blocked_missions], [color1, color2, color3, color4, color5], [hair_frame, flip_h]]
var item_preset  # [id, type, ship_slot_id]

static func create(_item_preset = null, _npc_preset = null) -> CustomObjectSpawn:
    var newResource : CustomObjectSpawn = CustomObjectSpawn.new()

    newResource.npc_preset = _npc_preset
    newResource.item_preset = _item_preset

    return newResource
