game_mode = 0
cursor = {}
cursor.index = 0
p = {}

function cursor.update(self)
    -- Move Cursor
    if consume_x_press() and input_x ~= 0 then
        cursor.index += input_x
    end
    if consume_y_press() and input_y ~= 0 then
        cursor.index += 3*input_y
    end
    -- #TODO: Handle bounds

    -- Action
    if consume_jump_press() then
        -- Find an adjacent empty room
        swap_index = -1
        if room_table[cursor.index] == -1 then
            swap_index = cursor.index-1
        elseif room_table[cursor.index + 2] == -1 then
            swap_index = cursor.index+1
        elseif room_table[cursor.index - 2] == -1 then
            swap_index = cursor.index-3
        elseif room_table[cursor.index + 4] == -1 then
            swap_index = cursor.index+3
        end

        -- Swap rooms
        if swap_index >= 0 then
            room_table[swap_index + 1] = room_table[cursor.index + 1]
            room_table[cursor.index + 1] = -1
        end
    end
end

function _init()
	p = instantiate(player, 7*8, 12*8)
end

function approach(x,t,s)
    return x < t and min (x + s, t) or max(x - s, t)
end



function _update()
	update_input()

    --if consume_action_press() then
       -- game_mode = (game_mode + 1) % 2
    -- end

    if game_mode == 1 then cursor.update() end
    if game_mode == 0 then
        
        for a in all(actors) do
            if not input_action then
                a:update()
            end
        end
    end
end

function _draw()
    if game_mode == 0 then
        cls(1)
        -- camera(p.x - 64, p.y - 64)
        camera(camera_x, camera_y)

        -- rectfill(0,      0, 16 * 8 - 1, 16*8 - 1, 2)
        -- rectfill(16 * 8, 0, 16 * 16 -1, 16*8 - 1, 3)

        --map(32,0,0,0, 16, 16 )
        --map(48,0,16 * 8,0, 16, 16 )
        draw_map()
        
        for a in all(actors) do
            a:draw()
        end

        print(p.map_id, camera_x,camera_y)
    elseif game_mode == 1 then -- draw room
        cls(2)
        camera(0, 0)

        local sprite_0 = 17
        for index, room_id in pairs(room_table) do
            sprite_id = room_id >= 0 and sprite_0 + room_id or 0
            spr(sprite_id, 48 + (index-1) % 3 * 8, 48 + flr((index-1) / 3) * 8)
        end
        -- draw cursor
        spr(3, 48 + cursor.index % 3 * 8, 48 + flr(cursor.index / 3) * 8)
    end
end