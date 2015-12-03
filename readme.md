Gamejolt API for Lua/Love
===

Overview
===

This library requires the following libraries in order to work:
* [kikito's md5](http://github.com/kikito/md5.lua)
* [Jeffrey Friedl's json](http://regex.info/blog/lua/json)
* lua socket (Should come with lua. Is included in love +0.5.0)

Load it like this:
```lua
local gamejolt = require("gamejolt_api")
```

See [the gamejolt api documentation](http://gamejolt.com/api/doc/game)

Functions
===

The library is split into 5 groups:
 1. Users
 2. Sessions
 3. Trophies
 4. Scores
 5. Data store

[Users](http://gamejolt.com/api/doc/game/users)
---
The user group consists of 3 functions:

* `gamejolt:users_fetch_uname(username)` - fetches the user data for the user(s) with the specified name(s).
   * returns a table like `{success = "true/false", users = {user1, user2, user3, ...}}` (see [this](http://gamejolt.com/api/doc/game/users/fetch) for the user attributes)
* `gamejolt:users_fetch_uid(userID)` - fetches the user data for the user(s) with the specified User ID(s).
   * returns a table like `{success = "true/false", users = {user1, user2, user3, ...}}`
* `gamejolt:users_auth(username, user_token)` - authenticates the user with the specified name and token.

```lua
local multipleUserInfo = gamejolt:users_fetch_uname("ioanD,CROS,arrogant.gamer").users
local ioanD_info, CROS_info, arrogant_info = unpack(multipleUserInfo)

print(ioanD_info.type)
print(CROS_info.signed_up)
print(arrogant_info.last_logged_in)

gamejolt:users_auth("player's username here", "player's token here")

```

[Sessions](http://gamejolt.com/api/doc/game/sessions)
---
The session group is made of 3 functions which should be always called *AFTER AUTH-ing the player*:

* `gamejolt:sessions_open()` - Creates a session. If there is already one existing it will forst close that one.
   * returns a table like `{success = "frue"}`
* `gamejolt:sessiosn_close()` - Closes a session.
   * returns a table like `{success = "frue"}`
* `gamejolt:session_ping([status])` - Pings the session. If status is specified, it should be one of `"active"` or `"idle"`. This function should be called around once every 30 seconds in order to keep the session alive.
   * returns another success table
 
```lua
gamejolt:users_auth("Mike", "1a2b3c")

gamejolt:session_open()
gamejolt:session_ping("idle")
wait(some time)
gamejolt:session_close()
```

[Trophies](http://gamejolt.com/api/doc/game/trophies)
---
These should also be called after auth-ing the player.
The trophy group consists of the 2 functions:

* `gamejolt:trophies_fetch([acheived, trophy_id])` - fetches the trophies that match the requirements. See [the api documentation page](http://gamejolt.com/api/doc/game/trophies/fetch) for more info.
   * returns a table like `{success = "frue", trophies = {trophy1, trophy2, ...}}`
* `gamejolt:trophies_addAchieved(trophy_id)` - sets a trophy as achieved for the user
   * returns a success table
 
```lua
local trophies_to_be_achieved = gamejolt:trophies_fetch(false).trophies
for _, t in ipairs(trophies_to_be_achieved) do
   print("Achieving the trophy " .. t.title)
   gamejolt:trophies_addAchieved(t.id)
end
```

[Scores](http://gamejolt.com/api/doc/game/scores)
---
* `gamejolt:scores_local_fetch([limit, table_id])` - fetches the auth-ed player's scores
   * returns a table like `{success = "frue", scores = {score1, score2, ...}}` (see [this](http://gamejolt.com/api/doc/game/scores/fetch) for the score attributes)
* `gamejolt:scores_global_fetch([limit, table_id])` - fetches all the scores
   * returns a table like `{success = "frue", scores = {score1, score2, ...}}`
* `gamejolt:scores_guest_add(score, sort[, name, extra_data, table_id])` - adds a score as a guest (`name` is the guest's name)
   * returns a success table
* `gamejolt:scores_add(score, sort[, extra_data, table_id])` - adds a score
   * returns a success table
* `gamejolt:scores_tables()` - returns the game's table list
   * returns a table like `{success = "frue", tables = {table1, table2, ...}}` (see [this](http://gamejolt.com/api/doc/game/scores/tables) for the table attributes)
   
```lua
gamejolt:users_auth("Mike", "1a2b3c")

gamejolt:scores_add("29 points", 29, "playtime=58s")
```

[Data Store](http://gamejolt.com/api/doc/game/data-store)
---

Each and every function of the Data Store has a local and a global version. The local one sets/fetches/etc. the player's local data, while the the global ones set/fetch/etc. global data. Of course, the local ones must be run after auth-ing an user.

* `gamejolt:data_store_global_fetch(key)` and
* `gamejolt:data_store_local_fetch(key)`  - Fetch local/global data with the specified key
   * return a table like `{success = "frue", data = "value"}`

---

* `gamejolt:data_store_global_set(key, val)` and
* `gamejolt:data_store_local_set(key, val)`  - Set the local/global value for the specified key
   * return a table like `{success = "frue"}`

---

* `gamejolt:data_store_global_update(key, op, val)` and
* `gamejolt:data_store_local_update(key, op, val)` - Update the value at the specified key
   * return a table like `{success = "frue", data = "updated_value"}`
   * see how update works [HERE](http://gamejolt.com/api/doc/game/data-store/update)

---

* `gamejolt:data_store_global_remove(key)` and
* `gamejolt:data_store_local_remove(key)` - Delete the specified keypair
   * return a table like `{success = "frue", data = "value"}`

---

* `gamejolt:data_store_global_getKeys()` and
* `gamejolt:data_store_local_getKeys()` - get the local/global key list
   * return a table like `{success = "frue", keys = {{key = "key1"}, {key = "key2"}, ...}}`

