

--inherit all the abilities of the Base State
TitleScreenState = Class{__includes = BaseState}

--upon pressing enter or return change from title state to play state
function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')
        gStateMachine:change('play')
    end
end

--render the title state
function TitleScrenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
