function NewPlayer(x,y,color,right,left,jump)

    local Player = {}
    Player.X               = x
    Player.Y               = y
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
    Player.Bounce          = 5 --diviseur de la vitesse du module
    Player.WalkForce       = 4000 -- force appliquée quant le joueur avance
    Player.JumpForce       = 40000 -- force appliquée quant le joueur saute
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
    
    function Player.SumForces()
    
        Player.ApplyForce(0,G) --Gravity
    
        Player.Reaction()
    
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
    
        Player.GroundFriction()
    
        Player.AirFriction()
            
    end 
    
    function Player.update(dt)
        Player.SumForces()      
    
        Player.AccelerationX = Player.ForceX
        Player.AccelerationY = Player.ForceY
        
    
        Player.SpeedX = Player.SpeedX +Player.AccelerationX * dt
        Player.SpeedY = Player.SpeedY +Player.AccelerationY * dt
            
        Player.X =Player.X +Player.SpeedX * dt
        Player.Y =Player.Y +Player.SpeedY * dt
    
        Player.ForceX = 0
        Player.ForceY = 0
    end
    
    function Player.draw()
        love.graphics.setColor(Player.Color)
        love.graphics.rectangle("fill",Player.X-Player.Width/2,Player.Y-Player.Height/2,Player.Width,Player.Height)
       
    end
    return Player
    
    end
    