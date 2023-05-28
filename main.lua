game_mode = 1
cursor = {}
cursor.index = 0

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
	a = {}
	a.x=64
	a.y=120
    a.acc=0.5
	a.dx=0
	a.dy=0
    a.mspeed=2
    a.move = move
end

function approach(x,t,s)
    local dir = sgn(t-x)
    x += s * dir
    if dir > 0 and x > t then x = t end
    if dir < 0 and x < t then x = t end
    return x
end

function move()
    local tx = a.x + a.dx
    local ty = a.y + a.dy

    local ofx = sgn(a.dx) > 0 and 7 or 0
    if fget(get_map_at(tx + ofx , a.y), 0) or fget(get_map_at(tx + ofx , a.y + 7), 0) then  tx = a.x end
    a.x = tx; 

    local ofy = sgn(a.dy) > 0 and 7 or 0
    if fget(get_map_at(a.x, ty + ofy), 0) or fget(get_map_at(a.x + 7, ty + ofy), 0) then ty = a.y end
    a.y = ty;

    if a.x > 504 then
		a.x = 504
	elseif a.x < 0 then
		a.x = 0
	end
	if a.y > 120 then
		a.y = 120
	elseif a.y < 0 then
		a.y = 0
	end
end

function _update()
	update_input()

    if consume_action_press() then
        game_mode = (game_mode + 1) % 2
    end

    if game_mode == 1 then cursor.update() end
    if game_mode == 0 then
        a.dx = approach(a.dx, input_x * a.mspeed, a.acc)
        a.dy = approach(a.dy, input_y * a.mspeed, a.acc)
        if input_run then a.mspeed = 4
        else a.mspeed = 2 end

        move()	
    end
end

function _draw()
    if game_mode == 0 then
        cls(1)
        camera(a.x - 64, a.y - 64)

        rectfill(0,0,16 * 8 - 1, 16*8 - 1, 2)
        rectfill(16 * 8 - 1,0,16 * 16 - 1, 16*8 - 1, 3)

        --map(32,0,0,0, 16, 16 )
        --map(48,0,16 * 8,0, 16, 16 )
        draw_map()
        spr(1, a.x, a.y)
    elseif game_mode == 1 then -- draw room
        cls(1)
        camera(0, 0)

        local sprite_0 = 17
        for index, room_id in pairs(room_table) do
            sprite_id = room_id >= 0 and sprite_0 + room_id or 0
            spr(sprite_id, 48 + (index-1) % 3 * 8, 48 + flr((index-1) / 3) * 8)
        end
        -- draw cursor
        spr(2, 48 + cursor.index % 3 * 8, 48 + flr(cursor.index / 3) * 8)
    end
end