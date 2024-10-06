extends Node

var max_creature_count = 100
var musicVolume = 0.0
var fxVolume = 0.0

var loadGame : bool

enum ITEM_SET {RED_SHRIMP, GREEN_SHRIMP, BLUE_SHRIMP,
PH_65_BUFFER, PH_72_BUFFER, PH_85_BUFFER, NATURAL_SALT, DECHLORINATOR,
PH_TEST_KIT, SALINITY_TEST_KIT}

var items_dict = {}

var cash
