Platform = {}

Ground = {}
    Ground.X = 0
    Ground.Y =  Yecran*2/3
    Ground.Width =Xecran
    Ground.Height = Yecran/3
    Ground.Friction = 6
LimitsLevels = {}
    LimitsLevels.Left = 0
    LimitsLevels.Right = Xecran

function PlatformCollision(entity,platform) --gere la collision entre un objet et une plateforme
    if entity.Y + entity.Height/2 >= platform.Y then
        entity.Y = platform.Y - entity.Height/2 
        entity.Grounded = true
        entity.CurrentPlatform = platform
        entity.SpeedY = 0
    end
end

function WallCollision(entity,Wall) --gere la collision entre un objet et un mur (Wip)
    if entity.X - entity.Width/2 <=Wall.Left then
        entity.X = Wall.Left + entity.Width/2 
        entity.SpeedX = -entity.SpeedX/entity.Bounce
    elseif entity.X + entity.Width/2 >= Wall.Right then
        entity.X = Wall.Right - entity.Width/2 
        entity.SpeedX = -entity.SpeedX/entity.Bounce
    end
end

function Platform.update()
    PlatformCollision(Player1,Ground)
    WallCollision(Player1,LimitsLevels)
end

function Platform.draw()
    love.graphics.setColor(Color.LightOrange)
    love.graphics.rectangle("fill",Ground.X,Ground.Y,Ground.Width,Ground.Height)
end
