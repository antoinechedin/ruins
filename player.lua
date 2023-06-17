player = new_prefab(1)
player.t_jump_grace = 0
player.t_var_jump = 0
player.auto_jump = false
player.var_jump = false
player.jump_speed = 0
player.map_id = 0

function player.init(self)
    self.x += 4
    self.y += 4
    self.hit_x = -3
    self.hit_y = -2
    self.hit_w = 6
    self.hit_h = 6

    self.map_id = get_map_id(self.x / 8, self.y / 8)
    camera_x = -8
    camera_y = -8

end


function player.jump(self)
    consume_jump_press()
    self.t_jump_grace = 0
    self.jump_speed = -5.5
    self.speed_y = self.jump_speed
    self.t_var_jump = 0
    self.var_jump = true
    sfx(0)
end


function player.update(self)
    local on_ground = self:check_solid(0,1)
    if on_ground then
        self.t_jump_grace = 4
    else
        self.t_jump_grace -= 1
    end

    -- Facing
    if input_x ~= 0 then
        self.facing = input_x
    end

    -- Run
    local target, accel = 0, 0.2
    if on_ground then
        target, accel = 2, 0.8
    else
        target, accel = 2, 0.4
    end
    
    self.speed_x = approach(self.speed_x, target * input_x, accel)

    -- Gravity
    if not on_ground then
        if abs(self.speed_y) < 0.2 and input_jump then
            self.speed_y = min(self.speed_y + 0.4, 6)
        else
            self.speed_y = min(self.speed_y + 0.7, 6)
        end
    end

    -- Variable Jump
    if self.speed_y < 0 then
        if self.var_jump and (not input_jump and not self.auto_jump) then
            self.var_jump = false
            self.speed_y = -0.2
        end
    else
        self.var_jump = false
        self.auto_jump = false
    end

    -- Jump
    if input_jump_pressed > 0 then
        if self.t_jump_grace > 0 then
            self:jump()
        end
    end

    -- Move
    self:move_x(self.speed_x, self.on_collide_x)
	self:move_y(self.speed_y, self.on_collide_y)  
    
    -- Sprite
    if not on_ground then
        self.spr = 2.9
    elseif input_x ~= 0 then
        self.spr += 0.333
        self.spr = 1 + (1 + self.spr) % 2
    else
        self.spr = 1.9
    end


    -- Camera
    local new_map_id = get_map_id(self.x / 8, self.y / 8)
    if new_map_id ~= self.map_id then
        local map_x = new_map_id * 14 % 42
        local map_y = flr(new_map_id / 3) * 14
        camera_target_x = map_x * 8 - 8
        camera_target_y = map_y * 8 - 8
        camera_transition = true
        if self.var_jump then self.auto_jump = true end
    end
    self.map_id = new_map_id

    -- Debug
    --self.spr = 1 + max(sgn(self.jump_grace - 1), 0)
end

function player.draw(self)
    spr(self.spr, self.x - 4, self.y - 4, 1, 1, self.facing ~= 1)
end