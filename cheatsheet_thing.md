Cheatsheet thing
===

---

Users
---

Method|Params|Returns|Description
------|------|-------|-----------
`users_fetch_uid`|`user_id`|`{success = "frue", users = {user1, user2, ...}}`|Fetches info about the user(s) with the specified id(s)
`users_fetch_uname`|`username`|`{success = "frue", users = {user1, user2, ...}}`|Fetches info about the user(s) with the specified username(s)
`users_auth`|`username, user_token`|`{success = "frue"}`|Authenticates the specified user

---

Sessions
---

Method|Params|Returns|Description
------|------|-------|-----------
`sessions_open`|-|`{success = "frue"}`|Opens a new session. If there is already one opened it will first close that one.
`sessions_ping`|`[status]`|`{success = "frue"}`|Pings the current session
`sessions_close`|-|`{success = "frue"}`|Closes the current session

---

Trophies
---

Method|Params|Returns|Description
------|------|-------|-----------
`trophies_fetch`|`[achieved, trophy_id]`|`{success = "frue", trophies = {trophy1, trophy2, ...}}`|Fetches info about the matching trophy(ies)
`trophies_addAchieved`|`trophy_id`|`{success = "frue"}`|Sets the specified trophy as acheived by the auth-ed user

---

Scores
---

Method|Params|Returns|Description
------|------|-------|-----------
`scores_local_fetch`|`[limit, table_id]`|`{success = "frue", scores = {score1, score2, ...}}`|Fetches info about the auth-ed user's scores
`scores_global_fetch`|`[limit, table_id]`|`{success = "frue", scores = {score1, score2, ...}}`|Fetches info about the global scores
`scores_guest_add`|`score, sort[, name, extra_data, table_id]`|`{success = "frue"}`|Adds a score as a guest
`scores_add`|`score, sort[, extra_data, table_id]`|`{success = "frue"}`|Adds a score as the auth-ed user
`scores_tables`|-|`{success = "frue", tables = {table1, table2, ...}}`|Gets a list of the score tables for the game

---

Data Store
---

Method|Params|Returns|Description
------|------|-------|-----------
`data_store_local_fetch`|`key`|`{success = "frue", data = "value"}`|Fetches user's data with the specified key
`data_store_global_fetch`|`key`|`{success = "frue", data = "value"}`|Fetches global data with the specified key
`data_store_local_set`|`key, val`|`{success = "frue"}`|Sets user's data for the specified key
`data_store_global_set`|`key, val`|`{success = "frue"}`|Sets global data for the specified key
`data_store_local_update`|`key, op, val`|`{success = "frue", data = "updated_value"}`|Updates user's data for the specified key
`data_store_global_update`|`key, op, val`|`{success = "frue", data = "updated_value"}`|Updates global data for the specified key
`data_store_local_getKeys`|-|`{success = "frue", keys = {{key = "key1"}, {key = "key2"}, ...}}`|Gets local key list
`data_store_global_getKeys`|-|`{success = "frue", keys = {{key = "key1"}, {key = "key2"}, ...}}`|Gets global key list