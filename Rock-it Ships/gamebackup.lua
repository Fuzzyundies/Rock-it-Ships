
local composer = require( "composer" )
require "math"

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local inputDevices = system.getInputDevices()

for i = 1,#inputDevices do
    local device = inputDevices[i]
    print( device.descriptor )
end

local physics = require ("physics")
physics.start()
physics.setGravity(0,0)

local sheetOptions = 
{
	frames = 
	{
		{ -- Asteroid 1
			x = 0,
			y = 0,
			width = 102,
			height = 85
		},
		{ -- Asteroid 2
			x = 0,
			y = 85,
			width = 90,
			height = 83
		},
		{ -- Asteroid 3
			x = 0,
			y = 168,
			width = 100,
			height = 97
		},
		{ -- Ship
			x = 0,
			y = 265,
			width = 98,
			height = 79
		},
		{ -- Laser
			x = 98,
			y = 265,
			width = 98,
			height = 40
		},	
	},
}

local objectSheet = graphics.newImageSheet("gameObjects.png", sheetOptions)

local sheetOptions2 = 
{
	frames = 
	{		
		{ -- Ship
			x = 0,
			y = 265,
			width = 5,
			height = 40
		},
		{ -- Laser
			x = 98,
			y = 265,
			width = 50,
			height = 20
		},	
	},
}

local objectSheet2 = graphics.newImageSheet("gameObjects2.png", sheetOptions)

local sheetOptions3 =
{
	frames = 
	{		
		{ -- Shield
			x = 0,
			y = 0,
			width = 200,
			height = 200
		},
	},
}

local objectSheet3 = graphics.newImageSheet("shield3.png", sheetOptions3)

local sheetOptions4 =
{
	frames = 
	{		
		{ -- Explosion
			x = 0,
			y = 0,
			width = 300,
			height = 300
		},
	},
}

local objectSheet4 = graphics.newImageSheet("explosion2.png", sheetOptions4)

local sheetOptions5 =
{
	frames = 
	{		
		{ -- Explosion
			x = 0,
			y = 0,
			width = 800,
			height = 800
		},
	},
}

local objectSheet5 = graphics.newImageSheet("asteroid1.png", sheetOptions5)


local sheetOptions6 =
{
	frames = 
	{		
		{ -- healthBack
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet6 = graphics.newImageSheet("healthBack.png", sheetOptions6)

local sheetOptions7 =
{
	frames = 
	{		
		{ -- healthP1
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet7 = graphics.newImageSheet("healthP11.png", sheetOptions7)

local sheetOptions8 =
{
	frames = 
	{		
		{ -- healthP1
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet8 = graphics.newImageSheet("healthP12.png", sheetOptions8)

local sheetOptions9 =
{
	frames = 
	{		
		{ -- healthP1
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet9 = graphics.newImageSheet("healthP13.png", sheetOptions9)

local sheetOptions10 =
{
	frames = 
	{		
		{ -- healthP1
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet10 = graphics.newImageSheet("healthP14.png", sheetOptions10)

local sheetOptions11 =
{
	frames = 
	{		
		{ -- healthP2
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet11 = graphics.newImageSheet("healthP21.png", sheetOptions11)

local sheetOptions12 =
{
	frames = 
	{		
		{ -- healthP2
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet12 = graphics.newImageSheet("healthP22.png", sheetOptions12)

local sheetOptions13 =
{
	frames = 
	{		
		{ -- healthP2
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet13 = graphics.newImageSheet("healthP23.png", sheetOptions13)

local sheetOptions14 =
{
	frames = 
	{		
		{ -- healthP2
			x = 0,
			y = 0,
			width = 1000,
			height = 500
		},
	},
}

local objectSheet14 = graphics.newImageSheet("healthP24.png", sheetOptions14)


local backNum = math.random( 4 )
local name = "nebula".. backNum..".png"

local forceMag = 0.005 
local turningSpeed = 8
local player1
local player2
local gameLoopTimer
local lives1Text
local lives2Text
local winnerText

local asteroidsTable = {}
local asteroidCount = 0;	

local bumper = {}
local screenLeft = display.screenOriginX
local screenWidth = display.contentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.contentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight

local hiddenGroup
local backGroup
local mainGroup
local uiGroup

local ship = {}
ship.__index = ship

function ship.new(name)
  local self = setmetatable({}, ship)
  self.myName = name
  self.lives = 3
  self.health = 4
  self.prevValue = 0
  self.died = false
  smallThruster = ""
  largeThruster = ""
  if(self.myName == "ship1")then
  	self.body = display.newImage(mainGroup, player1Ship, 100, 100)
  	self.body.x = display.contentWidth - 1820
  	self.body.y = display.contentCenterY
  	self.body:rotate(90)
  	self.healthBar = display.newImage(mainGroup, objectSheet6, self.body.x, self.body.y - 50)
  	self.healthBar:scale(0.1, 0.05)
  	self.healthBar1 = display.newImage(mainGroup, objectSheet10, self.body.x, self.body.y - 50)
  	self.healthBar1:scale(0.1, 0.05)
  	self.healthBar2 = display.newImage(mainGroup, objectSheet9, self.body.x, self.body.y - 50)
  	self.healthBar2:scale(0.1, 0.05)
  	self.healthBar3 = display.newImage(mainGroup, objectSheet8, self.body.x, self.body.y - 50)
  	self.healthBar3:scale(0.1, 0.05)
  	self.healthBar4 = display.newImage(mainGroup, objectSheet7, self.body.x, self.body.y - 50)
  	self.healthBar4:scale(0.1, 0.05)
  	if(player1Ship == "ship1P1.png") then
  		smallThruster = "thruster1Small.png"
  		largeThruster = "thruster1Large.png"
  	elseif(player1Ship == "ship2P1.png") then
  		smallThruster = "thruster2Small.png"
  		largeThruster = "thruster2Large.png"
  	else
  		smallThruster = "thruster3Small.png"
  		largeThruster = "thruster3Large.png"
  	end
  else
  	self.body = display.newImage(mainGroup, player2Ship, 100, 100)
  	self.body.x = display.contentWidth - 100
  	self.body.y = display.contentCenterY
 	self.body:rotate(-90)
 	self.healthBar = display.newImage(mainGroup, objectSheet6, self.body.x, self.body.y - 50)
  	self.healthBar:scale(0.1, 0.05)
 	self.healthBar1 = display.newImage(mainGroup, objectSheet14, self.body.x, self.body.y - 50)
  	self.healthBar1:scale(0.1, 0.05)
  	self.healthBar2 = display.newImage(mainGroup, objectSheet13, self.body.x, self.body.y - 50)
  	self.healthBar2:scale(0.1, 0.05)
  	self.healthBar3 = display.newImage(mainGroup, objectSheet12, self.body.x, self.body.y - 50)
  	self.healthBar3:scale(0.1, 0.05)
  	self.healthBar4 = display.newImage(mainGroup, objectSheet11, self.body.x, self.body.y - 50)
  	self.healthBar4:scale(0.1, 0.05)
 	if(player2Ship == "ship1P2.png") then
  		smallThruster = "thruster1Small.png"
  		largeThruster = "thruster1Large.png"
  	elseif(player2Ship == "ship2P2.png") then
  		smallThruster = "thruster2Small.png"
  		largeThruster = "thruster2Large.png"
  	else
  		smallThruster = "thruster3Small.png"
  		largeThruster = "thruster3Large.png"
  	end
  end
  self.thrusterSmall = display.newImage(mainGroup, smallThruster, 1000, 1000)
  self.thrusterSmall.alpha = 0
  self.thrusterSmall:scale(0.1,0.1)
  self.thrusterLarge = display.newImage(mainGroup, largeThruster, 1000, 1000)
  self.thrusterLarge.alpha = 0
  self.thrusterLarge:scale(0.1,0.1)
  self.body:scale(0.1,0.1)
  self.shield = display.newImage(mainGroup, objectSheet3, 0, self.body.x, self.body.y)
  self.shield.alpha = 0.5
  self.healthBar.alpha = 0.75
  self.body.myName = self.myName
  physics.addBody(self.body, {radius = 25, isSensor = true})
  self.body.linearDamping = 0.5
  self.direction = 0
  self.rotate = false
  self.push = false
  self.shieldIsActive = true
  print(self.shield.isActive)
  return self
end

function ship:fire()
  	self.angle = math.rad(self.body.rotation-90)
	self.xComp = math.cos(self.angle)
	self.yComp = math.sin(self.angle)
	if(self.myName == "ship1") then
		self.laser = display.newImage( mainGroup, objectSheet, 5, 98, 40 )
		self.laser.myName = "laser1"
	else
		self.laser = display.newImage( mainGroup, objectSheet2, 5, 98, 40 )
		self.laser.myName = "laser2"
	end
	physics.addBody( self.laser, "dynamic", { isSensor=true } )
	self.laser.isBullet = true
	self.laser.rotation = self.body.rotation
	
	self.laser.x, self.laser.y = self.body:localToContent( 420, -200 )

	self.laser:toBack()
	
	self.laser:applyLinearImpulse(150*forceMag*self.xComp, 150*forceMag*self.yComp, self.laser.x, self.laser.y)
end

function ship:breakShield()
	self.shieldIsActive = false
	self.shield.alpha = 0
	self.shield.xScale = 0.1
	self.shield.yScale = 0.1
	timer.performWithDelay( 200, ship:restoreShield())
	
end

function ship:restoreShield()
	transition.to(self.shield, {time = 250, alpha = 0.5, xScale = 1, yScale = 1})
	self.shieldIsActive = true
end

function explosion(xCoord, yCoord)
	exp = display.newImage(mainGroup, objectSheet4, 0, xCoord, yCoord)
	exp.alpha = 0
	exp:scale(0.1,0.1)
	exp.rotation = math.random(360)
	transition.to( exp, {time = 250, alpha = 1, xScale = 0.75, yScale = 0.75} )
	transition.to( exp, {delay = 250, time = 250, alpha = 0})
	--timer.performWithDelay(700,exp:removeSelf())
end

local function updateText()
	explode = true
	lives1Text.text = "Player 1 Lives: ".. player1.lives
	lives2Text.text = "Player 2 Lives: ".. player2.lives
end

local function createAsteroid()
		local newAsteroid = display.newImage(mainGroup, objectSheet5,102,85)
		newAsteroid:scale(0.2,0.2)
		table.insert(asteroidsTable, newAsteroid)
		physics.addBody(newAsteroid,"dynamic", { radius = 35, bounce = 0.8})
		newAsteroid.myName = "asteroid"
		local whereFrom = math.random(4)
		asteroidCount = asteroidCount + 1
 		--newAsteroid.alpha = 0
 		--spawnAsteroid()
		if (whereFrom == 1) then
			--From the Left

			newAsteroid.x = -60
			newAsteroid.y = math.random(display.contentHeight)
			newAsteroid:setLinearVelocity(math.random(40,120),math.random(20,60))
		elseif (whereFrom == 2) then
			-- From the Top
			--local newAsteroid = display.newImageRect(mainGroup, objectSheet,2,90,83)
			newAsteroid.x = math.random(display.contentWidth)
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity(math.random(-40,40),math.random(40,120))
		elseif (whereFrom == 3) then
			--From the bottom
			--local newAsteroid = display.newImageRect(mainGroup,objectSheet,2,90,83)
			newAsteroid.x = math.random(display.contentWidth)
			newAsteroid.y = display.contentHeight + 60
			newAsteroid:setLinearVelocity(math.random(-40,40),math.random(-120,-40))
		elseif (whereFrom== 4) then
			--local newAsteroid = display.newImageRect(mainGroup,objectSheet,3,98,79)
			newAsteroid.x = display.contentWidth + 60
			newAsteroid.y = math.random(display.contentHeight)
			newAsteroid:setLinearVelocity(math.random(-120,-40), math.random (20,60))
		end
	newAsteroid:applyTorque(-4,4)
end

local function makeBumpers()
	local fudgeNum = 102 + 2 -- extra positioning when rock is moved
	
	bumper["top"] = display.newRect(hiddenGroup, screenLeft, screenTop-fudgeNum, screenWidth, 2 )	
	bumper["top"].type = "bumper"
	bumper["top"].name = "top"
	bumper["top"].opposite = "bottom"
	bumper["top"].fudge = -fudgeNum
	physics.addBody( bumper["top"], "static", { isSensor=true } )

	bumper["left"] = display.newRect(hiddenGroup, screenLeft-fudgeNum, screenTop, 2, screenHeight+fudgeNum+2 )
	bumper["left"].type = "bumper"
	bumper["left"].name = "left"
	bumper["left"].opposite = "right"
	bumper["left"].fudge = -fudgeNum
	physics.addBody( bumper["left"], "static", { isSensor=true } )

	bumper["bottom"] = display.newRect(hiddenGroup, screenLeft-5, screenBottom+fudgeNum, screenWidth+10, 2 )
	bumper["bottom"].type = "bumper"
	bumper["bottom"].name = "bottom"
	bumper["bottom"].opposite = "top"
	bumper["bottom"].fudge = fudgeNum
	physics.addBody( bumper["bottom"], "static", { isSensor=true } )

	bumper["right"] = display.newRect(hiddenGroup, screenRight+fudgeNum, screenTop, 2, screenHeight+fudgeNum+2 )
	bumper["right"].type = "bumper"
	bumper["right"].name = "right"
	bumper["right"].opposite = "left"
	bumper["right"].fudge = fudgeNum
	physics.addBody( bumper["right"], "static", { isSensor=true } )	
end

local function onKeyEvent(event)
	if(player1.lives > 0 and player2.lives > 0) then
		local thisPlayer
	    if ( event.device.descriptor == "Gamepad 1" ) then
	        thisPlayer = player1
	    else
	        thisPlayer = player2
	    end
		if (event.keyName == "rightShoulderButton1") then
			if(event.phase == "down") then
				thisPlayer:fire()
				event.device:vibrate()
			end
		end
	end
end

Runtime:addEventListener( "key", onKeyEvent )

local function onAxisEvent(event)
	if(player1.lives > 0 and player2.lives > 0) then
		if(math.abs(event.normalizedValue) > 0.15) then
			print("Gamepad: "..event.device.descriptor.."Axis: "..event.axis.number.." Value: "..event.normalizedValue)
		end
		local thisAxis = event.axis.number
	    if ( event.device.descriptor == "Gamepad 1" ) then
	        thisPlayer = player1
	    else
	        thisPlayer = player2
	    end
    
    	if(thisAxis == 3) then
	    	
	    	if (math.abs(event.normalizedValue) > 0.15) then
				thisPlayer.rotation = event.normalizedValue * turningSpeed
				thisPlayer.rotate = true
			else
				thisPlayer.rotate = false
			end

		elseif(thisAxis == 5) then
	    	if (math.abs(event.normalizedValue) > 0.15) then
				thisPlayer.push = true
				if (event.normalizedValue > 0) then
					thisPlayer.direction = -90
					thisPlayer.angle = math.rad(thisPlayer.body.rotation + thisPlayer.direction)
					thisPlayer.xComp = math.cos(thisPlayer.angle)
					thisPlayer.yComp = math.sin(thisPlayer.angle)
				else
					thisPlayer.direction = 0
					thisPlayer.angle = 0
					thisPlayer.xComp = 0
					thisPlayer.yComp = 0
				end
			else
				thisPlayer.push = false
			end
		elseif(thisAxis == 6) then
	    	if (event.normalizedValue > 0.5 and thisPlayer.prevValue <= 0.5) then
				thisPlayer:fire()
				event.device:vibrate()
			end
			thisPlayer.prevValue = event.normalizedValue
		end
	end
end
Runtime:addEventListener( "axis", onAxisEvent )

local function onFrameEvent()
	p1 = true
	p2 = true
	if(player1.lives > 0 and player2.lives > 0) then

		player1.shield.x = player1.body.x
		player1.shield.y = player1.body.y
		player2.shield.x = player2.body.x
		player2.shield.y = player2.body.y
		player1.healthBar.x = player1.body.x
		player1.healthBar.y = player1.body.y - 50
		player1.healthBar1.x = player1.body.x
		player1.healthBar1.y = player1.body.y - 50
		player1.healthBar2.x = player1.body.x
		player1.healthBar2.y = player1.body.y - 50
		player1.healthBar3.x = player1.body.x
		player1.healthBar3.y = player1.body.y - 50
		player1.healthBar4.x = player1.body.x
		player1.healthBar4.y = player1.body.y - 50
		player2.healthBar.x = player2.body.x
		player2.healthBar.y = player2.body.y - 50
		player2.healthBar1.x = player2.body.x
		player2.healthBar1.y = player2.body.y - 50
		player2.healthBar2.x = player2.body.x
		player2.healthBar2.y = player2.body.y - 50
		player2.healthBar3.x = player2.body.x
		player2.healthBar3.y = player2.body.y - 50
		player2.healthBar4.x = player2.body.x
		player2.healthBar4.y = player2.body.y - 50
		player1.thrusterSmall.rotation = player1.body.rotation
		player1.thrusterSmall.x = player1.body.x
		player1.thrusterSmall.y = player1.body.y
		player1.thrusterLarge.rotation = player1.body.rotation
		player1.thrusterLarge.x = player1.body.x
		player1.thrusterLarge.y = player1.body.y
		player2.thrusterSmall.rotation = player2.body.rotation
		player2.thrusterSmall.x = player2.body.x
		player2.thrusterSmall.y = player2.body.y
		player2.thrusterLarge.rotation = player2.body.rotation
		player2.thrusterLarge.x = player2.body.x
		player2.thrusterLarge.y = player2.body.y

		if(player1.rotate) then
			player1.body.rotation = player1.body.rotation + player1.rotation
			player1.angle = math.rad(player1.body.rotation + player1.direction)
			player1.xComp = math.cos(player1.angle)
			player1.yComp = math.sin(player1.angle)
		end
		if(player1.push) then
			if(p1)then
				player1.thrusterLarge.alpha = 0
				player1.thrusterSmall.alpha = 1
			else
				player1.thrusterLarge.alpha = 1
				player1.thrusterSmall.alpha = 0
			end
			player1.body:applyLinearImpulse(1.5*forceMag*player1.xComp, 1.5*forceMag*player1.yComp, player1.body.x, player1.body.y)
		else
			player1.thrusterLarge.alpha = 0
			player1.thrusterSmall.alpha = 0
		end
			if(player2.rotate) then
			player2.body.rotation = player2.body.rotation + player2.rotation
			player2.angle = math.rad(player2.body.rotation + player2.direction)
			player2.xComp = math.cos(player2.angle)
			player2.yComp = math.sin(player2.angle)
		end
		if(player2.push) then
			if(p2)then
				player2.thrusterLarge.alpha = 0
				player2.thrusterSmall.alpha = 1
			else
				player2.thrusterLarge.alpha = 1
				player2.thrusterSmall.alpha = 0
			end
			player2.body:applyLinearImpulse(1.5*forceMag*player2.xComp, 1.5*forceMag*player2.yComp, player2.body.x, player2.body.y)
		else
			player2.thrusterLarge.alpha = 0
			player2.thrusterSmall.alpha = 0
		end
	end
end
Runtime:addEventListener("enterFrame", onFrameEvent)

local function gameLoop()

	-- Create new asteroid
		if (asteroidCount <= 10) then
			createAsteroid()
		end
	-- Remove asteroids which have drifted off screen
	for i = #asteroidsTable, 1, -1 do
		local thisAsteroid = asteroidsTable[i]

		if ( thisAsteroid.x < -100 or
			 thisAsteroid.x > display.contentWidth + 100 or
			 thisAsteroid.y < -100 or
			 thisAsteroid.y > display.contentHeight + 100 )
		then
			display.remove( thisAsteroid )
			table.remove( asteroidsTable, i )
			asteroidCount = asteroidCount - 1
		end
	end
end

local function restoreShip1()
	if(player1.lives > 0) then
		player1.body.isBodyActive = false
		player1.body.x = math.random(100,500)
		player1.body.y = math.random(400,900)

		-- Fade in the ship
		transition.to( player1.body, { alpha=1, time=1000,
			onComplete = function()
				player1.body:setLinearVelocity(0,0)
				player1.push = false
				player1.body.isBodyActive = true
				player1.died = false
				player1:restoreShield()
			end
		} )
	end
end

local function restoreShip2()
	if(player2.lives > 0) then
		player2.body.isBodyActive = false
		player2.body.x = math.random(1300,1800)
		player2.body.y = math.random(400,900)

		-- Fade in the ship
		transition.to( player2.body, { alpha=1, time=1000,
			onComplete = function()
				player2.body:setLinearVelocity(0,0)
				player2.push = false
				player2.body.isBodyActive = true
				player2.died = false
				player2:restoreShield()
			end
		} )
	end
end

local function endGame()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=800, effect="crossFade" })
end

local function onCollision( event )
local obj1 = event.object1
	local obj2 = event.object2
	if ( event.phase == "began" ) then
		if (obj1.type == "bumper" )then
        	local function wrap()
        		if obj1.name == "left" or obj1.name == "right" then
	        		obj2.x = bumper[obj1.opposite].x + obj1.fudge
	        		print("left and right")
	        	else
	        		obj2.y = bumper[obj1.opposite].y + obj1.fudge
	        		print("top and bottom")
        		end
        	end
        	timer.performWithDelay ( 1, wrap )
	
		elseif ( ( obj1.myName == "laser1" and obj2.myName == "asteroid" ) or
			 ( obj1.myName == "laser2" and obj2.myName == "asteroid" ) or
			 ( obj1.myName == "asteroid" and obj2.myName == "laser1" ) or
			 ( obj1.myName == "asteroid" and obj2.myName == "laser2" ) )
		then
			-- Remove both the laser and asteroid
			display.remove( obj1 )
			display.remove( obj2 )
			asteroidCount = asteroidCount -1
			for i = #asteroidsTable, 1, -1 do
				if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
					table.remove( asteroidsTable, i )
					break
				end
			end
			
		elseif ( ( obj1.myName == "ship1" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship1" )  or
				 ( obj1.myName == "laser2" and obj2.myName == "ship1" )  or
				 ( obj1.myName == "ship1" and obj2.myName == "laser2" ) )
		then
				display.remove("laser2")
			if(player1.shieldIsActive == false)then
				if ( player1.died == false ) then
					player1.died = true

					explosion(player1.body.x, player1.body.y)

					-- Update lives
					player1.lives = player1.lives - 1
					lives1Text.text = "Player 1 Lives: " .. player1.lives

					if ( player1.lives == 0 ) then
						display.remove( player1.body )
						winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
						display.remove( player2.body )
						timer.performWithDelay( 4000, endGame )
					else
						player1.body.alpha = 0
						timer.performWithDelay( 1000, restoreShip1 )
					end
				end
			else
				player1:breakShield()
			end

				
		elseif ( ( obj1.myName == "ship2" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship2" )  or
				 ( obj1.myName == "laser1" and obj2.myName == "ship2" )  or
				 ( obj1.myName == "ship2" and obj2.myName == "laser1" ) )
		then
				display.remove("laser1")
			if(player2.shieldIsActive == false) then
				if ( player2.died == false ) then
					player2.died = true

					-- Update lives
					player2.lives = player2.lives - 1
					lives2Text.text = "Player 2 Lives: " .. player2.lives

					if ( player2.lives == 0 ) then
						display.remove( player2.body )
						winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
						display.remove( player1.body )
						timer.performWithDelay( 4000, endGame )
					else
						player2.body.alpha = 0
						timer.performWithDelay( 1000, restoreShip2 )
					end
				end
			else
				player2:breakShield()
			end
		end
	end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	physics.pause() --Temp pause the physics engine

	hiddenGroup = display.newGroup()
	sceneGroup:insert( hiddenGroup )

	backGroup = display.newGroup()
	sceneGroup:insert( backGroup )

	mainGroup = display.newGroup()
	sceneGroup:insert( mainGroup )

	uiGroup = display.newGroup()
	sceneGroup:insert( uiGroup )

	local background = display.newImageRect( backGroup, name, 1920, 1080 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	makeBumpers()

	player1 = ship.new("ship1")
	player2 = ship.new("ship2")


	lives1Text = display.newText(uiGroup, "Player 1 Lives: ".. player1.lives, 100, 20, native.SystemFont, 20)
	lives2Text = display.newText(uiGroup, "Player 2 Lives: ".. player2.lives, display.contentWidth - 100, 20, native.SystemFont, 20)

	Runtime:addEventListener( "key", onKeyEvent )
	Runtime:addEventListener( "collision", onCollision )


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay(500, gameLoop, 0 )



	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		composer.removeScene( "game" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
