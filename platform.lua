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



function Platform.update()
end

function Platform.draw()
    love.graphics.setColor(Color.LightOrange)
    love.graphics.rectangle("fill",Ground.X,Ground.Y,Ground.Width,Ground.Height)
end
