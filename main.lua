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
AirFriction = 2
GroundFriction = 6
CptPlatform    = 0

require("color")
require("grid")
require("platform")
require("player")


Map = NewMap(50,50,50)

Player1 = NewPlayer(Xecran/6,Yecran/10,Color.Pink,'d','q','space','lshift')

Plaforms  = {

NewPlatform(0,18,30,5,GroundFriction),-- Ground
NewPlatform(38,0,1,25,GroundFriction),-- LeftWall
NewPlatform(0,0,1,25,GroundFriction),-- RightWall
NewPlatform(0,0,40,1,GroundFriction),-- Ceiling
NewPlatform(10,14,13,4,GroundFriction),-- Obstacle
NewPlatform(20,10,10,2,GroundFriction),-- Floating platform
NewPlatform(30,21,10,2,GroundFriction),-- Hole
NewPlatform(8,6,8,1,GroundFriction),-- highest platform

}




function love.load()
end

function love.update(dt)
    Player1.update(dt)
    for _, platfrom in pairs(Plaforms) do
        platfrom.update()
    end

end

function love.draw()
    love.graphics.setBackgroundColor(Color.LightOrange)
    for _, platfrom in pairs(Plaforms) do
        platfrom.draw()
    end
    Player1.draw()
    Map.draw()
    --[[ love.graphics.setColor(Color.Blue)
    love.graphics.print(Player1.AccelerationX) ]]
end



