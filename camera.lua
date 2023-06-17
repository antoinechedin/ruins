camera_x = 0
camera_y = 0
camera_frac_x = 0
camera_frac_y = 0
camera_target_x = 0
camera_target_y = 0
camera_transition = false

function update_camera()
    if camera_transition then
        camera_frac_x += (camera_target_x - camera_x) * 0.3
        local move = flr(camera_frac_x + 0.5) -- Round frac
        camera_frac_x -= move
        camera_x += move
        
        camera_frac_y += (camera_target_y - camera_y) * 0.3
        move = flr(camera_frac_y + 0.5) -- Round frac
        camera_frac_y -= move
        camera_y += move

        if camera_x == camera_target_x and camera_y == camera_target_y then
            camera_transition = false
        end
    end
end