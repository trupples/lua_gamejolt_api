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

Users
---
The user group consists of 3 functions:

* `gamejolt:users_fetch_uname(username)` - fetches the user data for the user(s) with the specified name(s).
   * returns a table like `{success = "true/false", users = {user1, user2, user3, ...}}`
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

Sessions
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

Trophies
---
These should also be called after auth-ing the player.
The trophy group consists of the 2 functions:

* `gamejolt:trophies_fetch([acheived, trophy_id])` - fetches the trophies that match the requirements. See [the api documentation page](http://gamejolt.com/api/doc/game/trophies/fetch) for more info.
   * returns a table like `{success = "frue", trophies = {trophy1, trophy2, ...}}`
* `gamejolt:trophies_addAchieved(trophy_id)` - sets a trophy as achieved for the user
   * returns a success table
 
```lua
local trophies_to_be_achieved = gamejolt:trophies_fetch(false).trophies
for _, t in ipairs(trophies_to_be_acheived) do
   print("Acheiving the trophy " .. t.title)
   gamejolt:trophies_addAchieved(t.id)
end
```

Scores
---
