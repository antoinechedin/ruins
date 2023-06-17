room_table = {6,0,3}

function get_map_at(x,y)
    -- Tile coordinate
    x = flr(x/8)
    y = flr(y/8)

    -- Map Coordinate
    local map_x = flr(x / 16)
    local map_y = flr(y / 16)
    local map_id = map_x + map_y * 8

    
    if map_id > #room_table - 1 then return 0 end
    if map_id < 0 then return 0 end

    local room_id = room_table[map_id + 1]
    local room_x = flr(room_id % 8) * 16
    local room_y = flr(room_id / 8) * 16
    
    local local_x = x - map_x * 16
    local local_y = y - map_y * 16
 
    return mget(room_x + local_x, room_y + local_y)
end

function draw_map()
    for map_id, room_id in pairs(room_table) do
        map_id -= 1
        local map_x = map_id * 16 % 128
        local map_y = flr(map_id / 8) * 16
        local room_x = room_id * 16 % 128
        local room_y = flr(room_id / 8) * 16
        map(room_x, room_y, map_x * 8, map_y * 8, 16, 16)

    end
end
