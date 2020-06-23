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

Player1 = NewPlayer(Xecran/6,Yecran/10,Color.LightRed,'d','q','space')
Player2 = NewPlayer(Xecran/3,Yecran/10,Color.Pink,'right','left','up')

Ground  = NewPlatform(0,18,30,5,1,5)
LeftWall = NewPlatform(38,0,1,25,2,5)
RightWall =  NewPlatform(0,0,1,25,3,5)
Ceiling  = NewPlatform(0,0,40,1,4,5)
Obs      = NewPlatform(10,14,13,4,5,5)
Float    = NewPlatform(20,10,10,2,6,5)
Hole =  NewPlatform(30,21,10,2,7,5)
Plushaut = NewPlatform(8,6,8,1,8,5)


Plaforms = {Ground,LeftWall,RightWall,Ceiling,Obs,Float,Hole,Plushaut} 


function love.load()
end

function love.update(dt)
    Player1.update(dt)
    Player2.update(dt)
    for i, platfrom in ipairs(Plaforms) do
        platfrom.update()
    end

end

function love.draw()
    love.graphics.setBackgroundColor(Color.DarkBlue)
    for i, platfrom in ipairs(Plaforms) do
        platfrom.draw()
    end
    Player1.draw()
    Player2.draw()
    Map.draw()
    love.graphics.setColor(Color.Red)
    love.graphics.print(math.floor(Player1.Y))
end

function love.keypressed(key)
    if key=="escape" then
        love.event.quit()
    end
end

