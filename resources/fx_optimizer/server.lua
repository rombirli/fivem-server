local playerFxCooldowns = {}

AddEventHandler('ptFxEvent', function(sender, data)
    local sourceStr = tostring(sender)
    local currentTime = GetGameTimer()

    -- Initialize tracking for the player if it doesn't exist
    if not playerFxCooldowns[sourceStr] then
        playerFxCooldowns[sourceStr] = { time = currentTime, count = 0 }
    end

    local pd = playerFxCooldowns[sourceStr]

    -- Reset the tracking bucket every 1000ms (1 second)
    if currentTime - pd.time > 1000 then
        pd.time = currentTime
        pd.count = 0
    end

    -- Increment the particle count for this frame/request
    pd.count = pd.count + 1

    -- CRITICAL LIMIT: If a player requests more than 15 network particles per second,
    -- it is physically impossible to do via standard gameplay. They are using a menu boost.
    if pd.count > 15 then
        -- CancelEvent() drops the particle completely, keeping your pool safe at 0/511
        CancelEvent()
        
        -- Optional: Print a warning to your server console so you can see who is doing it
        if pd.count == 16 then 
            print(("^1[FX PROTECT] Dropped excessive particle spam from Player ID: %s (Likely Menyoo Horn Boost)^7"):format(sender))
        end
    end
end)

-- Clean up tracking when a player disconnects
AddEventHandler('playerDropped', function()
    local sourceStr = tostring(source)
    if playerFxCooldowns[sourceStr] then
        playerFxCooldowns[sourceStr] = nil
    end
end)