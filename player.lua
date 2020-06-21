Player = {}

Player1 = {}
Player1.X               = Xecran*1/6  
Player1.Y               = Yecran*1/9
Player1.ForceX          = 0
Player1.ForceY          = 0
Player1.SpeedX          = 0
Player1.SpeedY          = 0
Player1.AccelerationX   = 0
Player1.AccelerationY   = 0
Player1.ScaleX          = 1
Player1.ScaleY          = 1
Player1.Width           = 50 * Player1.ScaleX
Player1.Height          = 50 * Player1.ScaleY
Player1.Angle           = 0
Player1.Grounded        = false
Player1.Color           = Color.LightRed
Player1.CurrentPlatform = nil
Player1.Bounce          = 5 --diviseur de la vitesse du module
Player1.WalkForce       = 4000 -- force appliquée quant le joueur avance
Player1.JumpForce       = 40000 -- force appliquée quant le joueur saute
Player1.AirControl      = 4   --diviseur de la force horizontale appliquée lorsque le joueur est dans les airs
Player1.Controls        = {}
    Player1.Controls.Right = 'd'
    Player1.Controls.Left  = 'q'
    Player1.Controls.Jump  = 'space'

function Player.ApplyForce(entity,force)
    entity.ForceX =entity.ForceX + force[1]
    entity.ForceY =entity.ForceY + force[2]
end

function Player.GroundFriction (player)-- ralentit le joueur sur le sol 
    if player.Grounded  then 
        Player.ApplyForce(player,{ -player.CurrentPlatform.Friction * player.SpeedX ,0}) 
    end
end

function Player.AirFriction (player)-- ralentit le joueur sur le sol 
    if not player.Grounded  then 
        Player.ApplyForce(player,{ -AirFriction * player.SpeedX ,0}) 
    end
end


function Player.Reaction(player)
    if player.Grounded then
        Player.ApplyForce(player,{0,-G})        
    end
    
end

function Player.SumForces(player)

    Player.ApplyForce(player,{0,G}) --Gravity

    Player.Reaction(player)

    if love.keyboard.isDown(player.Controls.Right)  then --droite
        if player.Grounded then
            Player.ApplyForce(player,{player.WalkForce,0})
        else
            Player.ApplyForce(player,{player.WalkForce/player.AirControl,0})
        end

    end

    if love.keyboard.isDown(player.Controls.Left)  then--gauche
        if player.Grounded then
            Player.ApplyForce(player,{-player.WalkForce,0})
        else
            Player.ApplyForce(player,{-player.WalkForce/player.AirControl,0})
        end
    end

    if love.keyboard.isDown(player.Controls.Jump)  and player.Grounded  then -- saut
        Player.ApplyForce(player,{0,-player.JumpForce})
        player.Grounded = false
        player.CurrentPlatform = nil
        
    end

    Player.GroundFriction(player)

    Player.AirFriction(player)
        
end 


function Player.Physics(dt,player) 
    Player.SumForces(player)      

    player.AccelerationX = player.ForceX
    player.AccelerationY = player.ForceY
    

    player.SpeedX = player.SpeedX +player.AccelerationX * dt
    player.SpeedY = player.SpeedY +player.AccelerationY * dt
        
    player.X =player.X +player.SpeedX * dt
    player.Y =player.Y +player.SpeedY * dt

    player.ForceX = 0
    player.ForceY = 0
        
end

function Player.display(player)
    love.graphics.setColor(player.Color)
    love.graphics.rectangle("fill",player.X-player.Width/2,player.Y-player.Height/2,player.Width,player.Height)
    
end


function Player.update(dt)
    Player.Physics(dt,Player1)
end

function Player.draw()
    Player.display(Player1)
end

