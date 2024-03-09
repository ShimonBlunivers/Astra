class_name CustomObjectSpawn extends Resource

# TODO

var npc_preset #    [id, ItemType]
var item_preset #   [id, name]

static func create(_item_preset = null, _npc_preset = null) -> CustomObjectSpawn:
    var newResource : CustomObjectSpawn = CustomObjectSpawn.new()

    newResource.npc_preset = _npc_preset
    newResource.item_preset = _item_preset

    return newResource
