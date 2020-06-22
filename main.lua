--title           :Base de platformer avec RFD
--description     :
--author          :PAP
--date            :20200618
--version         :1.1
--Language        :lua
--==============================================================================
io.stdout:setvbuf('no')
mainFont = love.graphics.newFont(14)
Xecran,Yecran      =  love.window.getDesktopDimensions()
love.window.setMode(Xecran,Yecran,{fullscreen})

G = 1500
AirFriction = 1.1

require("color")
require("grid")
require("platform")
require("player")


Map = NewMap(50,50,50)
Player1 = NewPlayer(Xecran/2,Yecran/10,Color.LightRed,'d','q','space')
Ground  = NewPlatform(0,18,40,5,1,5)

Plaforms = {Ground} 


function love.load()
end

function love.update(dt)

    Player1.update(dt)
    Ground.update()
end

function love.draw()
    love.graphics.setBackgroundColor(Color.DarkBlue)
    Ground.draw()
    Player1.draw()
    Map.draw()
end

function love.keypressed(key)
    if key=="escape" then
        love.event.quit()
    end
end

