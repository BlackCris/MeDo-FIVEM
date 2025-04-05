RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, typ)
    local src = source
    local name = GetPlayerName(src)
    local playerId = src

    -- 发送客户端显示
    TriggerClientEvent('3dme:triggerDisplay', -1, text, src, typ, name, playerId)

    -- 发送到 Discord
    local webhook = "https://discord.com/api/webhooks/1129813555559026829/spESqbKj48QIFvj-Rt9slx-dijr5A66SwUCN1q-0qkWGQZCUtetK7mTztzcau9MvQk7Q"
    local embed = {
        {
            ["title"] = "/" .. typ,
            ["description"] = "**" .. name .. " (ID: " .. playerId .. ")**\\n" .. text,
            ["color"] = typ == "me" and 16777215 or 8388736,
            ["footer"] = { ["text"] = os.date("%Y-%m-%d %H:%M:%S") }
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({
        username = "RP Logs",
        embeds = embed
    }), { ["Content-Type"] = "application/json" })
end)
