-- Force Blips and Overhead Names on player spawn
CreateThread(function()
    while true do
        -- Loop through all active players on the client side
        for _, playerId in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(playerId)
            
            if DoesEntityExist(ped) then
                -- 1. Force Overhead Names
                -- Creates a standard gamer tag above the player's head
                local tag = CreateFakeMpGamerTag(ped, GetPlayerName(playerId), false, false, "", 0)
                SetMpGamerTagVisibility(tag, 0, true) -- Component 0 is the name string
                
                -- 2. Force Map Blips
                -- Checks if the player already has a blip; if not, creates one
                local blip = GetBlipFromEntity(ped)
                if not DoesBlipExist(blip) then
                    blip = AddBlipForEntity(ped)
                    SetBlipSprite(blip, 1) -- Standard player blip dot
                    SetBlipScale(blip, 0.8)
                    SetBlipCategory(blip, 7) -- Other players category
                    
                    -- Optional: Show heading indicator on the blip
                    ShowHeadingIndicatorOnBlip(blip, true)
                end
            end
        end
        -- Run this check every 2 seconds to optimize performance
        Wait(2000)
    end
end)