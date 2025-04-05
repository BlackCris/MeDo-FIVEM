local activeMessages = {}

RegisterCommand('me', function(source, args, raw)
    local text = table.concat(args, " ")
    if text == nil or text == '' then return end
    TriggerServerEvent('3dme:shareDisplay', text, 'me')
end)

RegisterCommand('do', function(source, args, raw)
    local text = table.concat(args, " ")
    if text == nil or text == '' then return end
    TriggerServerEvent('3dme:shareDisplay', text, 'do')
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, typ, senderName, playerId)
    local srcId = GetPlayerFromServerId(source)
    if not srcId or srcId == -1 then return end
    if typ ~= "me" and typ ~= "do" then return end

    activeMessages[srcId] = activeMessages[srcId] or {}
    activeMessages[srcId][typ] = {
        text = text,
        typ = typ,
        start = GetGameTimer(),
        expires = GetGameTimer() + Config.DisplayTime
    }

    -- 判断是否戴面罩（component 1 是 mask）
    local isAnon = false
    local targetPed = GetPlayerPed(srcId)
    if targetPed and DoesEntityExist(targetPed) then
        local drawable = GetPedDrawableVariation(targetPed, 1)
        if drawable ~= 0 then
            isAnon = true
        end
    end

    -- 显示聊天
    local label = typ == 'me' and '^5[me]^0' or '^6[do]^0'
    local displayName = isAnon and 'Anonim:' or (senderName .. ' (ID: ' .. playerId .. ')')
    TriggerEvent('chat:addMessage', {
        args = { label .. ' ^7' .. displayName, text }
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local myCoords = GetEntityCoords(PlayerPedId())

        for srcId, typeData in pairs(activeMessages) do
            local ped = GetPlayerPed(srcId)
            if ped ~= -1 then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(myCoords - pedCoords)

                if distance < Config.DisplayDistance then
                    local offset = Config.TextOffset
                    local messagesToRender = {}

                    for _, typ in ipairs({"me", "do"}) do
                        local msg = typeData[typ]
                        if msg and GetGameTimer() < msg.expires then
                            table.insert(messagesToRender, msg)
                        end
                    end

                    for i = 1, #messagesToRender do
                        local msg = messagesToRender[i]
                        local timeLeft = msg.expires - GetGameTimer()
                        local alpha = 100
                        if timeLeft < 1000 then
                            alpha = math.floor((timeLeft / 1000) * 100)
                        end

                        local textColor = {255, 255, 255}
                        local bgColor = msg.typ == 'me' and {41, 41, 41} or {90, 0, 90}
                        DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + offset, msg.text, textColor, bgColor, alpha)
                        offset = offset + 0.15
                    end
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text, textColor, bgColor, alpha)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(textColor[1], textColor[2], textColor[3], 215)
        SetTextEntry("STRING")
        SetTextCentre(1)

        local maxLength = 60
        local splitText, lineCount = {}, 0

        for line in text:gmatch("[^\n]+") do
            while #line > maxLength do
                table.insert(splitText, line:sub(1, maxLength))
                line = line:sub(maxLength + 1)
            end
            table.insert(splitText, line)
        end
        text = table.concat(splitText, "\n")
        lineCount = #splitText

        AddTextComponentString(text)
        DrawText(_x, _y)

        local textWidth = MeasureStringWidth(text, 4, 0.35)
        local height = lineCount * 0.025
        DrawRect(_x, _y + (height / 2), textWidth + 0.01, height, bgColor[1], bgColor[2], bgColor[3], alpha)
    end
end

function MeasureStringWidth(str, font, scale)
    BeginTextCommandWidth("STRING")
    AddTextComponentSubstringPlayerName(str)
    SetTextFont(font)
    SetTextScale(scale, scale)
    return EndTextCommandGetWidth(1)
end
