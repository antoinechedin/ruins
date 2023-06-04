player = new_prefab(1)
player.jump_grace = 0


function player.jump(self)
    consume_jump_press()
    self.jump_grace = 0
    self.speed_y = -8
end

function player.update(self)
    local on_ground = self:check_solid(0,1)
    if on_ground then
        self.jump_grace = 4
    else
        self.jump_grace -= 1
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
        self.speed_y = min(self.speed_y + 0.8, 8)
    end

    -- Jump
    if input_jump_pressed > 0 then
        if self.jump_grace > 0 then
            self:jump()
        end
    end

    -- Move
    self:move_x(self.speed_x, self.on_collide_x)
	self:move_y(self.speed_y, self.on_collide_y)    

    -- Debug
    --self.spr = 1 + max(sgn(self.jump_grace - 1), 0)
end
