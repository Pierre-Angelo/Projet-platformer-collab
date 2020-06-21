--title           :Base de platformer avec RFD
--description     :
--author          :PAP
--date            :20200618
--version         :1.1
--Language        :lua
--==============================================================================
io.stdout:setvbuf('no')
Xecran,Yecran      =  love.window.getDesktopDimensions()
love.window.setMode(Xecran,Yecran,{fullscreen})

require("color")
require("platform")
require("player")

G = 1500
AirFriction = 1.1

Player1 = NewPlayer(Xecran/2,Yecran/10,Color.LightRed,'d','q','space')

function love.load()
end

function love.update(dt)
    Player1.update(dt)
    Platform.update()
    
end

function love.draw()
    love.graphics.setBackgroundColor(Color.DarkBlue)
    Platform.draw()
    Player1.draw()
end

function love.keypressed(key)
    if key=="escape" then
        love.event.quit()
    end

end

