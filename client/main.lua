RegisterNetEvent("me:event")
local players = {}


CreateThread(function()
    local lstr = ""
    while true do
        Wait(0)
        local tick = GetGameTimer()
        local str = ""
        local removes = {}
        for a, b in next, players do
            if b.rtime < tick then
                removes[#removes+1] = a
            end
            local p = GetPlayerFromServerId(a)
            if NetworkIsPlayerActive(p) then
                local ped = GetPlayerPed(p)
                if DoesEntityExist(ped) then
                    local coords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.0) --HEAD
                    local ons, x, y 
                    local dist = #(coords - GetEntityCoords(PlayerPedId()))
                    if dist > Config.Distance  then
                        removes[#removes+1] = a
                    end
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        ons, x, y = GetHudScreenPositionFromWorldPosition(coords.x, coords.y, coords.z+0.75)
                    else
                        ons, x, y = GetHudScreenPositionFromWorldPosition(coords.x, coords.y, coords.z+0.45)
                    end
                    if not ons then
                        if Config.NotUseDiscord == false then
                        x = (x*100)
                        y = (y*100)
                      
                        local icon = "<img style src="..b.dis..">"                                                           
                        if b.usage == true then 
                       
                            local html
                            html = "<div class='me' style=\"left: "..x.."%;top: "..y.."%; position: fixed;text-align: center;color: #ffffff;\">         <div class='inner' >      <h2 class='nametag'>"..b.name.."</h2>      <div class='metag'></div>          <div class='icon'>                        "..icon.."        </div>                 <p>"..b.message.."</p>         </div> </div>"
                            str = 
                            str..""..
                            html  
                        else 
                            local html
                            html = "<div class='me' style=\"left: "..x.."%;top: "..y.."%; position: fixed;text-align: center;color: #ffffff;\">         <div class='inner' >      <h2 class='nametag'>"..b.name.."</h2>      <div class='dotag'></div>          <div class='icon'>                        "..icon.."        </div>                 <p>"..b.message.."</p>         </div> </div>"
                            str = 
                            str..""..
                            html  
                        end
                    else 
                        x = (x*100)
                        y = (y*100)
                     
                        local icon = "<img style src="..Config.Defaultimage..">"                                                        
                        if b.usage == true then 
                       
                            local html
                            html = "<div class='me' style=\"left: "..x.."%;top: "..y.."%; position: fixed;text-align: center;color: #ffffff;\">         <div class='inner' >      <h2 class='nametag'>"..b.name.."</h2>      <div class='metag'></div>          <div class='icon'>                        "..icon.."        </div>                 <p>"..b.message.."</p>         </div> </div>"
                            str = 
                            str..""..
                            html  
                        else 
                            local html
                            html = "<div class='me' style=\"left: "..x.."%;top: "..y.."%; position: fixed;text-align: center;color: #ffffff;\">         <div class='inner' >      <h2 class='nametag'>"..b.name.."</h2>      <div class='dotag'></div>          <div class='icon'>                        "..icon.."        </div>                 <p>"..b.message.."</p>         </div> </div>"
                            str = 
                            str..""..
                            html  
                        end
                    end                                                        
                    end
                end
            end
        end
        if #removes > 0 then
            for a, b in ipairs(removes) do
                players[b] = nil
            end
        end
        if str ~= lstr then
            SendNUIMessage({meta = "me", html = str})
            lstr = str
        end
    end
end)




AddEventHandler("me:event", function(source, message, type1,name,dis,usage)
    source = tonumber(source)
    local sonid = GetPlayerFromServerId(source)
    local monid = PlayerId()

    if #(GetEntityCoords(GetPlayerPed(monid)) - GetEntityCoords(GetPlayerPed(sonid))) < Config.Distance  and HasEntityClearLosToEntity( GetPlayerPed(monid), GetPlayerPed(sonid), 17 ) then
        if type1 == 0 then 
            if(#message > 80) then
                message = string.sub(message, 1, 80) .. "..."
                if Config.permaName then
                    players[source] = {message = fix(message), rtime = 7000+GetGameTimer(), name=name, dis = dis , usage = usage} 
                else 
                    players[source] = {message = fix(message), rtime = 7000+GetGameTimer(), name='', dis = dis , usage = usage} 
                end
            else 
                if Config.permaName then
                    players[source] = {message = fix(message), rtime = 7000+GetGameTimer(), name=name, dis = dis , usage = usage}
                else
                    players[source] = {message = fix(message), rtime = 7000+GetGameTimer(), name='', dis = dis , usage = usage}
                end
            end
        end
    end
end)

function fix(string)
    string = string.gsub(string, "&", "&amp")
    string = string.gsub(string, "<", "&lt")
    string = string.gsub(string, ">", "&gt")
    string = string.gsub(string, "\"", "&quot")
    string = string.gsub(string, "'", "&#039")
    return string
end