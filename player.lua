function NewPlayer(x,y,color,right,left,jump,dash)

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
    Player.WalkForce       = 4000 -- force appliquée quant le joueur avance
    Player.JumpForce       = 55000 -- force appliquée quant le joueur saute
    Player.TotalDoubleJumps= 1
    Player.DoubleJumpCount = 0
    Player.DoubleJumpForce = Player.JumpForce * 5/6
    Player.DashForce       = 50000
    Player.TotalDash       = 1
    Player.DashCount       = 0
    Player.AirControl      = 4   --diviseur de la force horizontale appliquée lorsque le joueur est dans les airs
    Player.Width           = 20
    Player.Height          = 50
    Player.Angle           = 0
    Player.Grounded        = false
    Player.Time            = 0
    Player.Color           = color
    Player.CurrentPlatform = nil
    Player.Controls        = {}
        Player.Controls.Right = right
        Player.Controls.Left  = left
        Player.Controls.Jump  = jump
        Player.Controls.Dash  = dash

--########################################################################################################################################
--                                            Display and Animation
--########################################################################################################################################
    
    function Player.NewAnimation(imgsrc, nbFrames, nbSideFramesX,nbSideFramesY,fps,name)
        local Animation = {}
            Animation.Sheet            = love.graphics.newImage(imgsrc)
            Animation.Name             = name
            Animation.TotalFrames      = nbFrames
            Animation.NumberSideFramesX= nbSideFramesX
            Animation.NumberSideFramesY= nbSideFramesY
            Animation.FPS              = fps
            Animation.Width            = Animation.Sheet:getWidth() / Animation.NumberSideFramesX
            Animation.Height           = Animation.Sheet:getHeight() / Animation.NumberSideFramesY
            Animation.ScaleX           = 1/(Animation.Width/Player.Width)
            Animation.ScaleY           = 1/(Animation.Height/Player.Height)
        return Animation
        
    end
    Player.Animations      = {}
        Player.Animations.Idle       = Player.NewAnimation ("resources/assets/Idle.png",16,4,4,16,"Idle")
        Player.Animations.Run        = Player.NewAnimation ("resources/assets/Running.png",7,3,3,21,"Run")
        Player.Animations.Jump       = Player.NewAnimation ("resources/assets/Jumping.png",1,1,1,1,"Jump")
        Player.Animations.Landing    = Player.NewAnimation ("resources/assets/Landing.png",9,3,3,21,"land")
        Player.Animations.TurnAround = Player.NewAnimation ("resources/assets/TurnAround.png",1,1,1,1,"turnAround")
        Player.Animations.HiddenIdle = Player.NewAnimation ("resources/assets/LongIdle.png",40,6,7,17,"HiddenIdle")

    Player.CurrentAnimation = Player.Animations.Idle
    Player.ScaleX          = Player.CurrentAnimation.ScaleX *2.5
    Player.ScaleY          = Player.CurrentAnimation.ScaleY
    Player.CurrentFrame    = 0
    Player.XsideFrameCount = 0
    Player.YsideFrameCount = 0
    Player.HiddenIdleTimer = 0

    function Player.AnimationsReset ()
        Player.CurrentFrame = 0
        Player.XsideFrameCount = 0
        Player.YsideFrameCount = 0
    end

    
    
    function Player.Animate (dt)

        if Player.SpeedX/math.abs(Player.SpeedX) == Player.SpeedX/math.abs(Player.SpeedX) then  --inverse le sprite quand le personnage se retourne
            Player.ScaleX = Player.ScaleX * Player.SpeedX/math.abs(Player.SpeedX) * Player.ScaleX/math.abs(Player.ScaleX)
        end 
       
    --Run
        if math.abs(Player.SpeedX) > 5 and Player.CurrentAnimation ~= Player.Animations.Run and Player.Grounded then -- si la vitesse est superieur à un certain cap et que 
            Player.CurrentAnimation = Player.Animations.Run                                                          -- le joueur est sur le sol alors animation course
            Player.AnimationsReset()
        end
    --Turn around
        if Player.SpeedX/math.abs(Player.SpeedX) * Player.AccelerationX < 0 and Player.Grounded and  Player.CurrentAnimation ~= Player.Animations.TurnAroundand and Player.CurrentAnimation ~=Player.Animations.Idle and Player.CurrentAnimation ~= Player.Animations.HiddenIdle then -- si joueur freine alors TurnAround
            Player.CurrentAnimation = Player.Animations.TurnAround
            Player.AnimationsReset()
        end
    -- Idle
        if math.abs(Player.SpeedX) < 5  and Player.CurrentAnimation ~= Player.Animations.HiddenIdle and Player.CurrentAnimation ~= Player.Animations.Idle  and Player.Grounded and Player.CurrentAnimation ~= Player.Animations.Landing then -- si la vitesse est inferieur à un certain cap et que 
            Player.CurrentAnimation = Player.Animations.Idle                                                           -- le joueur est sur le sol alors animation idle 
            Player.AnimationsReset()
        end
    --HiddenIdle
        if Player.CurrentAnimation == Player.Animations.Idle and Player.Grounded then
            Player.HiddenIdleTimer = Player.HiddenIdleTimer + dt
        else
            Player.HiddenIdleTimer = 0
        end

        if Player.HiddenIdleTimer >= 17 then
            Player.CurrentAnimation = Player.Animations.HiddenIdle
            Player.AnimationsReset()
            
        end
    -- Jump 
        if not Player.Grounded then
            Player.CurrentAnimation = Player.Animations.Jump
            Player.AnimationsReset()
        end
        
        
        Player.Quad = love.graphics.newQuad(Player.XsideFrameCount*Player.CurrentAnimation.Width,Player.YsideFrameCount*Player.CurrentAnimation.Height,
                Player.CurrentAnimation.Width,Player.CurrentAnimation.Height,Player.CurrentAnimation.Sheet:getWidth(),Player.CurrentAnimation.Sheet:getHeight())
        Player.Time = Player.Time + dt
    
        if Player.Time >= 1/Player.CurrentAnimation.FPS then
                
            
            Player.XsideFrameCount = Player.XsideFrameCount + 1
    
            if Player.XsideFrameCount >= Player.CurrentAnimation.NumberSideFramesX then
                Player.XsideFrameCount = 0
                Player.YsideFrameCount = Player.YsideFrameCount + 1
            end
    
            Player.CurrentFrame = Player.CurrentFrame + 1
    
            if Player.CurrentFrame ==Player.CurrentAnimation.TotalFrames then
                if Player.CurrentAnimation ~= Player.Animations.HiddenIdle then
                    Player.AnimationsReset()
               else
                   Player.CurrentFrame =Player.CurrentAnimation.TotalFrames-1
                   Player.XsideFrameCount =3
                   Player.YsideFrameCount = 6
               end
            end
            
            Player.Time = 0
        end
        
    end

--########################################################################################################################################
--                                            Interaction and Physics
--########################################################################################################################################
    
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
            Player.DoubleJumpCount = 0
            Player.DashCount = 0
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
    end
    function Player.keypressed(key)   --Jump and double Jump
        if key == Player.Controls.Jump  then
            if Player.Grounded then
                Player.ApplyForce(0,-Player.JumpForce)
            elseif Player.DoubleJumpCount < Player.TotalDoubleJumps then
                Player.ApplyForce(0,-Player.DoubleJumpForce)
                Player.SpeedY = 0
                Player.DoubleJumpCount = Player.DoubleJumpCount + 1
            end
        end
        if key == Player.Controls.Dash and Player.DashCount < Player.TotalDash then
            Player.ApplyForce(Player.DashForce* Player.ScaleX/math.abs(Player.ScaleX),0)
            if Player.SpeedY > 0 then
                Player.SpeedY = 0
            end
            Player.DashCount = Player.DashCount +1
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

--########################################################################################################################################
--                                            Collisions
--########################################################################################################################################

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
                            Player.DoubleJumpCount = 0
                            Player.DashCount = 0
                        end
                    elseif j > Player.Ymap then
                        Player.Grounded = false
                    end

                end
            end
        end
    end

--########################################################################################################################################
--                                           Execution
--########################################################################################################################################

    function Player.update(dt)
        Player.Animate(dt)
        Player.Physics(dt)
        Player.Collisions()       
    end
    
    function Player.draw()
        love.graphics.setColor(Color.White)
        
        --love.graphics.rectangle("fill",Player.X - Player.Width/2,Player.Y-Player.Height/2,Player.Width,Player.Height)
        love.graphics.draw(Player.CurrentAnimation.Sheet,Player.Quad,Player.X,Player.Y+3,Player.Angle,Player.ScaleX*2.3,Player.ScaleY*2.3,Player.CurrentAnimation.Width/2,Player.CurrentAnimation.Height/2)
    end
    return Player
    
end