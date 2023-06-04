input_x = 0
input_x_pressed = 0
input_y_pressed = 0

input_jump = false
input_jump_pressed = 0

inout_action = false
input_action_pressed = 0

-- debug
input_y = 0
input_run = 0


function update_input()
    -- Axes
    local axis_x = (btn(1) and 1 or 0) - (btn(0) and 1 or 0)
    if axis_x ~= 0 and input_x == 0 then
        input_x_pressed = 4
    else
        input_x_pressed = axis_x ~= 0 and max(0, input_x_pressed-1) or 0
    end
    input_x = axis_x
    
    local axis_y = (btn(3) and 1 or 0) - (btn(2) and 1 or 0)
    if axis_y ~= 0 and input_y == 0 then
        input_y_pressed = 4
    else
        input_y_pressed = axis_y ~= 0 and max(0, input_y_pressed-1) or 0
    end
    input_y = axis_y

    -- #TODO: Better handle input_x_press and input_y_press when pressing 
    -- right and left (upd and down) at the same time 

    -- Jump
    local jump = btn(4)
    if jump and not input_jump then
        input_jump_pressed = 4
    else
        input_jump_pressed = jump and max(0, input_jump_pressed-1) or 0
    end
    input_jump = jump

    --Action
    local action = btn(5)
    if action and not input_action then
        input_action_pressed = 4
    else
        input_action_pressed = action and max(0, input_action_pressed-1) or 0
    end
    input_action = action
end

function consume_x_press()
    local val = input_x_pressed > 0
    input_x_pressed = 0
    return val
end

function consume_y_press()
    local val = input_y_pressed > 0
    input_y_pressed = 0
    return val
end

function consume_jump_press()
    local val = input_jump_pressed > 0
    input_jump_pressed = 0
    return val
end

function consume_action_press()
    local val = input_action_pressed > 0
    input_action_pressed = 0
    return val
end