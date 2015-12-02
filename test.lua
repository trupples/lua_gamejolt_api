local gamejolt = require("gamejolt_api")
require("test.print_r")

gamejolt:init(111240, "c20a6414a1e31a6d7f7a329a37c626a6")

gamejolt:users_auth("ioanD", "d08cf8")

print_r(gamejolt:scores_guest_add("20 points", "20", "Your good friend", "YOU HAVE FRIENDS?!?!?"))

print_r(gamejolt:scores_global_fetch())
