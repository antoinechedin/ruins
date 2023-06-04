prefabs = {}
actors = {}

actor = {}
actor.x = 0
actor.y = 0
actor.frac_x = 0
actor.frac_y = 0
actor.speed_x = 0
actor.speed_y = 0
actor.hit_x = 0
actor.hit_y = 0
actor.hit_w = 8
actor.hit_h = 8

function actor.update()
end

function actor.draw(self)
    spr(self.spr, self.x, self.y)
end

function actor.move_x(self, x, on_collide)
    self.frac_x += x
    local move = flr(self.frac_x + 0.5) -- Round frac_x
    
    self.frac_x -= move
    local sign = sgn(move)
    while move ~= 0 do
        if self:check_solid(sign, 0) then
            if on_collide then
                on_collide(self)
            end
            return
        else
            self.x += sign
            move -= sign
        end
    end
end

function actor.move_y(self, y, on_collide)
    self.frac_y += y
    local move = flr(self.frac_y + 0.5) -- Round frac_x
    
    self.frac_y -= move
    local sign = sgn(move)
    while move ~= 0 do
        if self:check_solid(0, sign) then
            if on_collide then
                on_collide(self)
            end
            return
        else
            self.y += sign
            move -= sign
        end
    end
end

function actor.check_solid(self, ox, oy)
    for i = (ox + self.x + self.hit_x), (ox + self.x + self.hit_x + self.hit_w - 1) do
		for j = (oy + self.y + self.hit_y), (oy + self.y + self.hit_y + self.hit_h - 1) do
			if fget(tile_at(i, j), 0) then
				return true
			end
		end
	end

    return false
end

function actor.on_collide_x(self)
    self.frac_x = 0
    self.speed_x = 0
end

function actor.on_collide_y(self)
    self.frac_y = 0
    self.speed_y = 0
end

lookup = {}
function lookup.__index(self, i) return self.base[i] end

function instantiate(prefab, x, y)
    local inst = {}
    inst.base = prefab
    inst.x = x
    inst.y = y
    setmetatable(inst, lookup)
    add(actors, inst)
    if inst.init then inst.init(inst) end -- #TODO: test with a ":"
    return inst
    
end

function new_prefab(spr)
    local prefab = {}
    prefab.base = actor
    prefab.spr = spr
    setmetatable(prefab, lookup)
    prefabs[spr] = prefab
    return prefab
end