function NewPlatform (x,y,width,height,frictionValue)
CptPlatform = CptPlatform + 1

local Platform = {}
Platform.Xmap      = x
Platform.Ymap      = y
Platform.WidthMap  = width
Platform.HeightMap = height
Platform.ID        = CptPlatform
Platform.Friction  = frictionValue
  


    
function Platform.update()
    for i = Platform.Xmap , Platform.Xmap + Platform.WidthMap -1 do
        for j =Platform.Ymap ,Platform.Ymap +Platform.HeightMap -1 do
            Map[i][j].Occupied = true
            Map[i][j].Platform = Platform.ID
        end
    end

end

function Platform.draw()
    for i = Platform.Xmap , Platform.Xmap + Platform.WidthMap -1 do
        for j =Platform.Ymap ,Platform.Ymap +Platform.HeightMap -1 do
            love.graphics.setColor(Color.LightRed)
            love.graphics.rectangle("fill",Map[i][j].X,Map[i][j].Y,Map[i][j].Size,Map[i][j].Size)
        end
    end
 
end

return Platform

end