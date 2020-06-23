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
    Player.WalkForce       = 4000 -- force appliquée quant le joueur avance
    Player.JumpForce       = 50000 -- force appliquée quant le joueur saute
    Player.AirControl      = 4   --diviseur de la force horizontale appliquée lorsque le joueur est dans les airs
    Player.Width           = 50 
    Player.Height          = 50 
    Player.Angle           = 0
    Player.Grounded        = false
    Player.Animations      = {}
        Player.Animations.Idle = {}
            Player.Animations.Idle.Sheet            = love.graphics.newImage("resources/assets/Idle_Animation.png")
            Player.Animations.Idle.TotalFrames      = 2
            Player.Animations.Idle.NumberSideFrames = 1
            Player.Animations.Idle.Width            = Player.Animations.Idle.Sheet:getWidth() / Player.Animations.Idle.NumberSideFrames
            Player.Animations.Idle.Height           = Player.Animations.Idle.Sheet:getHeight() / 2
            Player.Animations.Idle.FPS              =3
        Player.Animations.Run = {}
            Player.Animations.Run.Sheet            = love.graphics.newImage("resources/assets/Run_Animation.png")
            Player.Animations.Run.TotalFrames      = 7
            Player.Animations.Run.NumberSideFrames = 3
            Player.Animations.Run.Width            = Player.Animations.Run.Sheet:getWidth() / Player.Animations.Run.NumberSideFrames
            Player.Animations.Run.Height           = Player.Animations.Run.Sheet:getHeight() / Player.Animations.Run.NumberSideFrames
        Player.Animations.Jump = {}
            Player.Animations.Jump.Sheet            = love.graphics.newImage("resources/assets/Jump_Animation.png")
            Player.Animations.Jump.TotalFrames      = 23
            Player.Animations.Jump.NumberSideFrames = 5
            Player.Animations.Jump.Width            = Player.Animations.Jump.Sheet:getWidth() / Player.Animations.Jump.NumberSideFrames
            Player.Animations.Jump.Height           = Player.Animations.Jump.Sheet:getHeight() / Player.Animations.Jump.NumberSideFrames
    Player.CurrentAnimation = Player.Animations.Idle
    Player.ScaleX          = 1/(Player.CurrentAnimation.Width/Player.Width)
    Player.ScaleY          = 1/(Player.CurrentAnimation.Height/Player.Height)
    Player.CurrentFrame    = 0
    Player.XsideFrameCount = 0
    Player.YsideFrameCount = 0
    Player.Time            = 1
    Player.Color           = color
    Player.CurrentPlatform = nil
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

    function Player.Animate (dt)
        Player.Time = Player.Time + dt
        if Player.Time >= 1/Player.CurrentAnimation.FPS then
            Player.Quad = love.graphics.newQuad(Player.XsideFrameCount*Player.CurrentAnimation.Width,Player.YsideFrameCount*Player.CurrentAnimation.Height,Player.CurrentAnimation.Width,
            Player.CurrentAnimation.Height,Player.CurrentAnimation.Sheet:getWidth(),Player.CurrentAnimation.Sheet:getHeight())

            Player.XsideFrameCount = Player.XsideFrameCount + 1

            if Player.XsideFrameCount == Player.CurrentAnimation.NumberSideFrames then
                Player.XsideFrameCount = 0
                Player.YsideFrameCount = Player.YsideFrameCount + 1
            end

            Player.CurrentFrame = Player.CurrentFrame + 1

            if Player.CurrentFrame==Player.CurrentAnimation.TotalFrames then
                Player.CurrentFrame = 0
                Player.XsideFrameCount = 0
                Player.YsideFrameCount = 0
            end
            Player.Time = 0
        end
    end

    function Player.update(dt)
        Player.Physics(dt)      
        Player.Collisions()
        Player.Animate(dt)
    end
    
    function Player.draw()
        love.graphics.setColor(Color.White)
        love.graphics.draw(Player.CurrentAnimation.Sheet,Player.Quad,Player.X,Player.Y,Player.Angle,Player.ScaleX*5,Player.ScaleY*5,Player.Width/2,Player.Height/2)
        --love.graphics.rectangle("fill",Player.X - Player.Width/2,Player.Y-Player.Height/2,Player.Width,Player.Height)
       
    end
    return Player
    
end