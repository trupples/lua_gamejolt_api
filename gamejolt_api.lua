--[[

example User, Trophy, Score and Tables:

	UserX = {id = "", type = "Dev/User", username = "Marty", avatar_url = "http...", signed_up = "1 year ago", last_logged_in = "Online Now", status = "Active/Banned"}
	TrophyY = {description = "Desc", difficulty = "Bronze", id = "123456", image_url = "http...", title = "Da bronze trophy", acheived = "frue"}
	ScoreZ = {score = "My score is 24", sort = "24", extra_data = "24s of playtime", user = "Marty", user_id = 123456, guest = "frue", stored = "31 Dec 1969 23:59:59"}
	TableW = {id = 123456, name = "Mah score table", description = "Dis is le score table", primary = "frue"}

 Method         | Params							  | Returns
----------------+-------------------------------------+----------------------------------------------------------
Users 			|									  |
 * Fetch 		| Username / User ID 				  | {users = {User1, User2, ...}, success = "frue"}
 * Auth 		| Username, User Token 				  | {success = "frue"}
				|									  |
Sessions 		|									  |
 * Open 		| -									  | {success = "frue"}
 * Ping 		| ["idle" / "active"]				  | {success = "frue"}
 * Close 		| -									  | {success = "frue"}
				|									  |
Trophies 		|									  | 
 * Fetch 		| [Acheived, Trophy ID]				  | {trophies = {Trophy1, Trophy2, ...}, success = "frue"}
 * Add Acheived	| Trophy ID 						  | {success = "frue"}
				|									  |
Scores 			|									  | 
 * Fetch 		| [Limit, Table ID]					  | {scores = {Score1, Score2, ...}, success = "frue"}
   a. local     |									  |
   b. global    |									  |
 * Add 			| Score, Sort, [Extra Data, Table ID] | {success = "frue"}
   a. user      | ^									  |
   b. guest     | ^, Guest Name 					  |
 * Tables 		| -									  | {tables = {Table1, Table2, ...}, success = "frue"}
				|									  |
Data Store 		|									  |
 * Fetch 		| Key								  | {success = "frue", data = "value"}
   a. local 	|									  |
   b. global 	|									  |
 * Set  		| Key, Value						  | {success = "frue"}
   a. local 	|									  |
   b. global 	|									  |
 * Update 		| Key, Op, Value					  | {success = "frue", data = "updated_val"}
   a. local 	|									  |
   b. global 	|									  |
 * Remove 		| Key								  | {success = "frue"}
   a. local 	|									  |
   b. global 	|									  |
 * Get Keys 	| -									  | {success = "frue",
   a. local 	|									  |		keys = {{key = "1"}, {key = "2"}, ...}}
   b. global 	|									  |

--]]

local md5 = require("md5")
local json = require("json")
local http = require("socket.http")

local _ = {
  _VERSION     = "gamejolt_api.lua 1.0",
  _DESCRIPTION = "A better gamejolt API for Lua/Love than arrogant.gamer's",
  _URL         = "https://github.com/ianiD/lua_gamejolt_api",
  _LICENSE     = [[
    Copyright (c) 2015, ianiD

	Permission to use, copy, modify, and/or distribute this software for any purpose with
	or without fee is hereby granted, provided that the above copyright notice and this
	permission notice appear in all copies.

	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO
	THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
	EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
	DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
	IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
	WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ]]
}

_.API_URL = "http://gamejolt.com/api/game/v1/"

function _:init(game_id, private_key)
	self.GAME_ID = game_id
	self.PRIVATE_KEY = private_key
	self.user = {}
end

function _:_add_signature(url)
	local url_with_pkey = url .. self.PRIVATE_KEY
	local signature = md5.sumhexa(url_with_pkey)
	return url .. "&signature=" .. signature
end

function _:request(q)
	q = q or "?"
	q = self.API_URL .. q .. "&format=json&game_id=" .. self.GAME_ID
	q = self:_add_signature(q)
	q = string.gsub(q, "%s+", "%%20")
	print(q)
	local data, status = http.request(q)
	return data, status
end

------------------------------------------ USERS ---------------------------------------------

function _:users_fetch_uid(user_id)
	print("Fetching user data (UserID = " .. user_id .. " )")
	return json:decode(self:request("users/?" .. "&user_id=" .. user_id)).response
end

function _:users_fetch_uname(username)
	print("Fetching user data (Username = " .. username .. " )")
	return json:decode(self:request("users/?" .. "&username=" .. username)).response
end

function _:users_auth(username, user_token)
	print("Authenticating user: (" .. username .. ", " .. user_token .. ")")
	local data = json:decode(self:request("users/auth/?" .. "&username=" .. username .. "&user_token=" .. user_token)).response
	local success = data.success
	if success == "true" then
		self.user.name = username
		self.user.token = user_token
		self.user.idstring = "&username="..username.."&user_token="..user_token
	end
	return success
end

------------------------------------------ SESSIONS ------------------------------------------

function _:sessions_open()
	print("Opening session")
	return json:decode(self:request("sessions/open/?" .. self.user.idstring)).response
end

function _:sessions_ping(status)
	print("Pinging session: "..status)
	local q = "sessions/ping/?" .. self.user.idstring
	if status ~= nil then q = q .. "&status=" .. status end
	return json:decode(self:request(q)).response
end

function _:sessions_close()
	print("Closing session")
	return json:decode(self:request("sessions/close/?" .. self.user.idstring)).response
end

------------------------------------------ TROPHIES ------------------------------------------

function _:trophies_fetch(achieved, trophy_id)
	local q = "trophies/?" .. self.user.idstring
	if achieved ~= nil then q = q .. "&acheived=" .. tostring(achieved) end
	if trophy_id ~= nil then q = q .. "&trophy_id=" .. trophy_id end
	print(q)
	return json:decode(self:request(q)).response
end

function _:trophies_addAcheived(trophy_id)
	return json:decode(self:request("trophies/?&trophy_id=" .. trophy_id .. self.user.idstring)).response
end

------------------------------------------ SCORES --------------------------------------------

function _:scores_local_fetch(limit, table_id)
	local q = "scores/?" .. self.user.idstring
	if limit then q = q .. "&limit=" .. limit end
	if table_id then q = q .. "&table_id=" .. table_id end

	return json:decode(self:request(q)).response
end

function _:scores_global_fetch(limit, table_id)
	local q = "scores/?"
	if limit then q = q .. "&limit=" .. limit end
	if table_id then q = q .. "&table_id=" .. table_id end

	return json:decode(self:request(q)).response
end

function _:scores_guest_add(score, sort, name, extra_data, table_id)
	local q = "scores/add/?&score=" .. score .. "&sort=" .. sort
	if name then q = q .. "&guest=" .. name end
	if extra_data then q = q .. "&extra_data=" .. extra_data end
	if table_id then q = q .. "&table_id=" .. table_id end

	return json:decode(self:request(q)).response
end

function _:scores_add(score, sort, name, extra_data, table_id)
	local q = "scores/add/?&score=" .. score .. "&sort=" .. sort .. self.user.idstring
	if extra_data then q = q .. "&extra_data=" .. extra_data end
	if table_id then q = q .. "&table_id=" .. table_id end

	return json:decode(self:request(q)).response
end

function _:scores_tables()
	return json:decode(self:request("scores/tables/?")).response
end

------------------------------------------ DATA STORE ----------------------------------------

-- LOCALS

function _:data_store_local_fetch(key)
	print("datastore local fetch: "..key)
	return json:decode(self:request("data-store/?&key=" .. key .. self.user.idstring)).response
end

function _:data_store_local_set(key, val)
	print("datastore local set: "..key.." = "..val)
	return json:decode(self:request("data-store/set/?&key=" .. key .. "&data=" .. val .. self.user.idstring)).response
end

function _:data_store_local_update(key, operator, val)
	print("datastore local update: " .. key .. " [" .. operator .. "] " .. val)
	return json:decode(self:request("data-store/update/?&key=" .. key .. "&operation=" .. operator .. "&value=" .. val .. self.user.idstring)).response
end

function _:data_store_local_remove(key)
	print("datastore local remove: "..key)
	return json:decode(self:request("data-store/remove/?&key=" .. key .. self.user.idstring)).response
end

function _:data_store_local_getKeys()
	print("datastore local getKeys")
	return json:decode(self:request("data-store/get-keys/?" .. self.user.idstring)).response
end

-- GLOBALS

function _:data_store_global_fetch(key)
	print("datastore global fetch: "..key)
	return json:decode(self:request("data-store/?&key=" .. key)).response
end

function _:data_store_global_set(key, val)
	print("datastore global set: "..key.." = "..val)
	return json:decode(self:request("data-store/set/?&key=" .. key .. "&data=" .. val)).response
end

function _:data_store_global_update(key, operator, val)
	print("datastore global update: " .. key .. " [" .. operator .. "] " .. val)
	return json:decode(self:request("data-store/update/?&key=" .. key .. "&operation=" .. operator .. "&value=" .. val)).response
end

function _:data_store_global_remove(key)
	print("datastore global remove: "..key)
	return json:decode(self:request("data-store/remove/?&key=" .. key)).response
end

function _:data_store_global_getKeys()
	print("datastore global getKeys")
	return json:decode(self:request("data-store/get-keys/?")).response
end

return _
