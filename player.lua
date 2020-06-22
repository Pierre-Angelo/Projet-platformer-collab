function NewPlayer(x,y,color,right,left,jump)

    local Player = {}
    Player.X               = x
    Player.Y               = y
    Player.Xmap            = math.floor(Player.X/Map[0][0].Size)
    Player.Ymap            = math.floor(Player.Y/Map[0][0].Size)
    Player.ForceX          = 0
    Player.ForceY          = 0
    Player.SpeedX          = 0
    Player.SpeedY          = 0
    Player.AccelerationX   = 0
    Player.AccelerationY   = 0
    Player.ScaleX          = 1
    Player.ScaleY          = 1
    Player.Width           = 50 * Player.ScaleX
    Player.Height          = 50 * Player.ScaleY
    Player.Angle           = 0
    Player.Grounded        = false
    Player.Color           = color
    Player.CurrentPlatform = nil
    Player.WalkForce       = 4000 -- force appliquée quant le joueur avance
    Player.JumpForce       = 60000 -- force appliquée quant le joueur saute
    Player.AirControl      = 4   --diviseur de la force horizontale appliquée lorsque le joueur est dans les airs
    Player.Controls        = {}
        Player.Controls.Right = right
        Player.Controls.Left  = left
        Player.Controls.Jump  = jump
    
    function Player.ApplyForce(forceX,forceY)
        Player.ForceX =Player.ForceX + forceX
        Player.ForceY =Player.ForceY + forceY
    end
    
    function Player.GroundFriction ()-- ralentit le joueur sur le sol 
        if Player.Grounded  then 
            Player.ApplyForce( -Player.CurrentPlatform.Friction * Player.SpeedX ,0) 
        end
    end 
    
    function Player.AirFriction ()-- ralentit le joueur sur le sol 
        if not Player.Grounded  then 
            Player.ApplyForce( -AirFriction * Player.SpeedX ,0) 
        end
    end

    
    function Player.Reaction()
        if Player.Grounded then
            Player.ApplyForce(0,-G)        
        end
        
    end

    function Player.Movments ()
        if love.keyboard.isDown(Player.Controls.Right)  then --droite
            if Player.Grounded then
                Player.ApplyForce(Player.WalkForce,0)
            else
                Player.ApplyForce(Player.WalkForce/Player.AirControl,0)
            end
        end
    
        if love.keyboard.isDown(Player.Controls.Left)  then--gauche
            if Player.Grounded then
                Player.ApplyForce(-Player.WalkForce,0)
            else
                Player.ApplyForce(-Player.WalkForce/Player.AirControl,0)
            end
        end
    
        if love.keyboard.isDown(Player.Controls.Jump)  and Player.Grounded  then -- saut
            Player.ApplyForce(0,-Player.JumpForce)
            Player.Grounded = false
            Player.CurrentPlatform = nil
        end
    end
    
    function Player.SumForces()
     
        Player.ApplyForce(0,G) --Gravity
    
        Player.Reaction()
    
        Player.GroundFriction()
    
        Player.AirFriction() 

        Player.Movments()

    end 
 
    function Player.Physics(dt)
        Player.SumForces()      
    
        Player.AccelerationX = Player.ForceX
        Player.AccelerationY = Player.ForceY
        
    
        Player.SpeedX = Player.SpeedX +Player.AccelerationX * dt
        Player.SpeedY = Player.SpeedY +Player.AccelerationY * dt
            
        Player.X =Player.X +Player.SpeedX * dt
        Player.Y =Player.Y +Player.SpeedY * dt

        Player.Xmap = math.floor(Player.X/Map[0][0].Size)
        Player.Ymap = math.floor(Player.Y/Map[0][0].Size)
    
        Player.ForceX = 0
        Player.ForceY = 0

    end

    function Player.Collisions ()
        for i = Player.Xmap - 1 ,Player.Xmap + 1 do
            for j = Player.Ymap - 1, Player.Ymap + 1   do
                if  i == Player.Xmap or j == Player.Ymap then
                    if  Map[i][j].Occupied then
                        if Player.Xmap > i and Player.X-Player.Width/2 < Map[i][j].X + Map[0][0].Size then
                            Player.X = Map[i][j].X + Map[0][0].Size + Player.Width/2
                            Player.SpeedX = 0
                        elseif Player.Xmap < i and Player.X + Player.Width/2 > Map[i][j].X then
                            Player.X =  Map[i][j].X - Player.Width/2
                            Player.SpeedX = 0
                        end

                        if Player.Ymap > j and Player.Y - Player.Height/2 < Map[i][j].Y + Map[0][0].Size then
                            Player.Y = Map[i][j].Y + Map[0][0].Size + Player.Height/2
                            Player.SpeedY = 0
                        elseif Player.Ymap < j and Player.Y + Player.Height/2 > Map[i][j].Y then
                            Player.Y =  Map[i][j].Y - Player.Height/2
                            Player.Grounded = true
                            Player.CurrentPlatform = Plaforms[Map[i][j].Platform]
                            Player.SpeedY = 0
                        end
                    elseif j > Player.Ymap then
                        Player.Grounded = false
                    end

                end
            end
        end
    end

    function Player.update(dt)
        Player.Physics(dt)      
        Player.Collisions()
    end
    
    function Player.draw()
        love.graphics.setColor(Player.Color)
        love.graphics.rectangle("fill",Player.X-Player.Width/2,Player.Y-Player.Height/2,Player.Width,Player.Height)
       
    end
    return Player
    
end
    