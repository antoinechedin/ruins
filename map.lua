room_table = {0 ,1 ,2,3,4, 5,6,7,-1}

-- return map id at xy in tile space
function get_map_id(x, y)
    return flr(x / 14) % 3 + flr(y / 14) * 3
end

-- get sprite id at xy in tile space
function tile_at(x,y)
    -- Tile coordinate
    --x = flr(x/8)
    --y = flr(y/8)

    -- Map Coordinate
    local map_x = flr(x / 14)
    local map_y = flr(y / 14)
    local map_id = map_x % 3 + map_y * 3

    
    if map_id > #room_table - 1 then return 0 end
    if map_id < 0 then return 0 end

    local room_id = room_table[map_id + 1]
    if room_id < 0 then return 0 end
    
    local room_x = flr(room_id % 9) * 14
    local room_y = flr(room_id / 9) * 14
    
    local local_x = x - map_x * 14
    local local_y = y - map_y * 14
 
    return mget(room_x + local_x, room_y + local_y)
end

function draw_map()
    for map_id, room_id in pairs(room_table) do
        map_id -= 1 -- Lua starts array at 1
        local map_x = map_id * 14 % 42
        local map_y = flr(map_id / 3) * 14
        local room_x = room_id * 14 % 128
        local room_y = flr(room_id / 8) * 14
        map(room_x, room_y, map_x * 8, map_y * 8, 14, 14, 1)
    end
end
