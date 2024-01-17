class_name NPC extends Character

var difference = Vector2.ZERO

static var number_of_npcs = 0;

func init():
	nickname = "NPC_Kevin_" + str(number_of_npcs);
	number_of_npcs += 1;
	print(nickname, " SPAWNED on: " , position)

