AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    -- Variables --
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local steamid
    local license
    local discord
    local fivem
    local ip

    -- Put identifers to our variables --

    for k, v in ipairs(identifiers) do 
        if string.match(v, 'steam') then
            steamid = v 
            print('Steam id = ' .. v)

        elseif string.match(v, 'license:') then
            license = v 
            print('License: ' .. v)

        elseif string.match(v, 'discord') then
            discord = v 
            print('discord id = ' .. v)

        elseif string.match(v, 'fivem') then
            fivem = v 
            print('Fivem: ' .. v)

        elseif string.match(v, 'ip') then 
            ip = v 
            print('IP: ' .. v)
        end
    end

    if not steamid then
        deferrals.done('You need to have steam open to play on this server!')
    else
        deferrals.done()
        print('steam id is being fetched along with other identifiers.')

        MySQL.Async.fetchScalar('SELECT 1 FROM playerIdentifiers WHERE steamid = @steamid', {
            ['@steamid'] = steamid
        }, function (result)
            if not result then
                print('steam ID not found, inserting values into database.')

                MySQL.Async.execute('INSERT INTO playerIdentifiers (steamname, steamid, license, discord, fivem, ip) VALUES (@steamname, @steamid, @license, @discord, @fivem, @ip)', 
                {['@steamname'] = GetPlayerName(source), ['@steamid'] = steamid, ['@license'] = license, ['@discord'] = discord, ['@fivem'] = fivem, ['@ip'] = ip})
                print('Values have been inserted into database.')
            else
                print('stemaid found')
            end
        end)
    end
end)