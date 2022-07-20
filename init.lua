core.register_privilege("ranks","Allow manage ranks")
core.register_on_chat_message(function(name,message)
 local player = core.get_player_by_name(name)
 if not player then return end
 local pmeta = player:get_meta()
 if not pmeta then return end
 local rank = pmeta:get_string("rank")
 --if not rank or rank == "" then rank = "[Player] " end
 local color = pmeta:get_string("rankcolor")
 --if not color or color == "" then color = "#BBB" end
 if rank and rank ~= "" and core.check_player_privs(name, {shout = true}) then
 if core.get_modpath("irc") then
    irc.say("<"..name.."> "..core.strip_colors(message))
 end
 core.log("action","CHAT: "..core.format_chat_message(rank..name,core.strip_colors(message)))
 core.chat_send_all(core.format_chat_message(core.colorize(color,rank)..name,message))
 return true
 end
end)
core.register_chatcommand("getrank", {
 description="Get rank of player or you",
 params="[player]",
 func = function(name,param)
    local player
    if not param or param == "" then
        player = core.get_player_by_name(name)
    else
        player = core.get_player_by_name(param)
    end
    if not player then return false,"Invalid player" end
    local pmeta = player:get_meta()
    if not pmeta then return end
    local rank = pmeta:get_string("rank")
    if not rank or rank == "" then rank = "Player" end
    local color = pmeta:get_string("rankcolor")
    if not color or color == "" then color = "#BBB" end
    return true,player:get_player_name().."'s rank is "..core.colorize(color,rank)..", color: "..color
end})
core.register_chatcommand("setrank", {
 privs={ranks=true},
 description="Set rank of player",
 params="<player> <rank> <color>",
 func = function(name,param)
    local pname, rank, color = param:match("(%S+)%s+(%S+)%s+(.+)")
    if not (pname and rank and color) then return false,"Invalid params" end
    local player = core.get_player_by_name(pname)
    if not player then return false,"Invalid player" end
    local pmeta = player:get_meta()
    if not pmeta then return end
    pmeta:set_string("rank","["..rank.."] ")
    pmeta:set_string("rankcolor",color)
    player:set_nametag_attributes({text = core.colorize(color,"["..rank.."] ")..pname})
    return true,"Rank of "..pname..' now set to '..core.colorize(color,rank)
end})

core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    local pmeta = player:get_meta()
    if not pmeta then return end
    local rank = pmeta:get_string("rank")
    --if not rank or rank == "" then rank = "[Player] " end
    local color = pmeta:get_string("rankcolor")
    --if not color or color == "" then color = "#BBB" end
    player:set_nametag_attributes({text = core.colorize(color,rank)..name})
end)


core.register_chatcommand("players", {
         description = "List all players currently online.",
         func = function(name, _)
                 local onlineCount = #(core.get_connected_players())
                 local listString = onlineCount.." Online: "
                 local iterated=1
                 for _,player in ipairs(core.get_connected_players()) do
                         local ntag = player:get_nametag_attributes(player).text
                                 listString=listString..ntag
                         if iterated < onlineCount then
                                 listString=listString..", "
                         end
                         iterated=iterated+1
                 end
                 core.chat_send_player(name, listString)
         end
})
