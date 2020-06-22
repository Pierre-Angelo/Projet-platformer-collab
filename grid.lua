function CreateCase(size,i,j)
    local Case = {}
      Case.Size     = size  
      Case.Color    = Color.LightGrey
      Case.X        = (i)*Case.Size
      Case.Y        = (j)*Case.Size
      Case.Name     = (i..";"..j)
      Case.Platform = ""
      Case.Occupied    = false   --Indique l'état de l'emplacment X;Y, si il est Occupied le player ne peut pas y aller
  
    function Case.update()
    end
  
    function Case.draw(debug)
        debug = debug or false
        if debug then
            love.graphics.setColor(Case.Color)
            love.graphics.rectangle("line",Case.X,Case.Y,Case.Size,Case.Size)
            love.graphics.print(Case.Name,Case.X + Case.Size/2,Case.Y + Case.Size/2,0,1,1,mainFont:getWidth(Case.Name)/2,mainFont:getHeight(Case.Name)/2)                

            if Case.Occupied then 
                love.graphics.print(1, Case.X+Case.Size-10, Case.Y)
            else 
                love.graphics.print(0, Case.X+Case.Size-10, Case.Y)
            end
        end
    end
    return Case
end

function NewMap(cellSize, caseCountWidth, caseCountHeight)
    

local Grid ={}
    for i = 0, caseCountWidth do
        Grid[i] = {}
        for j = 0,caseCountHeight do
            Grid[i][j]=CreateCase(cellSize,i,j)
        end
    end

function Grid.draw()
    for i = 0, caseCountWidth do
        for j = 0,caseCountHeight do
            Grid [i][j].draw()
        end
    end
end
return Grid
end