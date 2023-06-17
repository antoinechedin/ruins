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

function input()
    if btn(4) then a.mspeed = 4
	else a.mspeed = 2 end

    local xdir = (btn(1) and 1 or 0) - (btn(0) and 1 or 0)
    local ydir = (btn(3) and 1 or 0) - (btn(2) and 1 or 0)

	a.dx = approach(a.dx, xdir * a.mspeed, a.acc)
    a.dy = approach(a.dy, ydir * a.mspeed, a.acc)
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
	input()
    move()	
end

function _draw()
	cls(1)
    camera(a.x - 64, a.y - 64)

    rectfill(0,0,16 * 8 - 1, 16*8 - 1, 2)
    rectfill(16 * 8 - 1,0,16 * 16 - 1, 16*8 - 1, 3)

    --map(32,0,0,0, 16, 16 )
    --map(48,0,16 * 8,0, 16, 16 )
    draw_map()
	spr(1, a.x, a.y)

    
end