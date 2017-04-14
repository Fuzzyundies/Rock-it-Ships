
local composer = require( "composer" )
require "math"

local scene = composer.newScene()
local backgroundMusicChannel1 = audio.play( backgroundMusicChannel, { channel=1, loops=-1, fadein=5000 } )
audio.setVolume( 1.0, { channel=1 } )
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
		{ -- shield
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

local sheetOptions15 =
{
	frames = 
	{		
		{ -- explosion
			x = 0,
			y = 0,
			width = 800,
			height = 800
		},
	},
}

local objectSheet15 = graphics.newImageSheet("explosionS.png", sheetOptions15)

local sheetOptions16 =
{
	frames = 
	{		
		{ -- explosion
			x = 0,
			y = 0,
			width = 800,
			height = 800
		},
	},
}

local objectSheet16 = graphics.newImageSheet("asteroid11.png", sheetOptions16)

local sheetOptions17 =
{
	frames = 
	{		
		{ -- explosion
			x = 0,
			y = 0,
			width = 800,
			height = 800
		},
	},
}

local objectSheet17 = graphics.newImageSheet("asteroid12.png", sheetOptions17)


local backNum = math.random( 4 )
local name = "nebula".. backNum..".png"

local forceMag = 0.005 
local turningSpeed = 8
local player1
local player2
local gameLoopTimer
local playerLivesText
local player1LivesText
local winnerText
local counter = 0

local objectTable = {}
local asteroidsTable = {}
local asteroidCount = 0;	

local asteroidBumper = {}
local otherBumper = {}
local laserBumper = {}

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

local	laser1Channel			 = audio.loadSound( "Shoot1.wav" )
local	laser2Channel			 = audio.loadSound( "Shoot2.wav" )
local	explosionChannel 		 = audio.loadSound( "Explosion.wav" )
local	backgroundMusicChannel 	 = audio.loadSound( "playMusic.mp3" )
local	asteroidcollideChannel 	 = audio.loadSound( "astroidHit.wav" )


--local explosionChannel = audio.play( explosionChannel, { channel=6 } )
--audio.setVolume( 1.0, { channel=6 } )

--local colliseChannel = audio.play( asteroidcollideChannel, { channel=7 } )
--audio.setVolume( 1.0, { channel=7 } )


function ship.new(name)
  local self = setmetatable({}, ship)
  self.name = name
  self.lives = 3
  self.energy = 5
  self.prevValue = 0
  self.died = false
  smallThruster = ""
  largeThruster = ""
  if(self.name == "ship1")then
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
  	self.body.name = "ship1"
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
  	self.body.name = "ship2"
  end
  self.body.type = "ship"
  self.body.health = 4
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
  self.body.name = self.name
  physics.addBody(self.body,"dynamic", {radius = 25, bounce = 0.5})
  self.body.linearDamping = 0.5
  self.direction = 0
  self.rotate = false
  self.push = false
  self.shieldIsActive = true
  self.body.hit = false
  return self
end

function ship:fire()
	self.energy = self.energy - 1
  	self.angle = math.rad(self.body.rotation-90)
	self.xComp = math.cos(self.angle)
	self.yComp = math.sin(self.angle)
	if(self.name == "ship1") then
		local shootChannel1 = audio.play( laser1Channel, { channel=4 })
		audio.setVolume( 1.0, { channel=4 } )
		self.laser = display.newImage( mainGroup, objectSheet, 5, 98, 40 )
		self.laser.name = "laser1"
	else
		local shootChannel2 = audio.play( laser2Channel, { channel=5 })
		audio.setVolume( 1.0, { channel=5 } )
		self.laser = display.newImage( mainGroup, objectSheet2, 5, 98, 40 )
		self.laser.name = "laser2"
	end
	physics.addBody( self.laser, "dynamic", { isSensor=true } )
	self.laser.isBullet = true
	self.laser.rotation = self.body.rotation
	
	self.laser.movedVertical = false
	self.laser.movedHorizontal = false
	table.insert(objectTable,self.laser)
	self.laser.type = "laser"

	self.laser.x, self.laser.y = self.body:localToContent( 420, -200 )
	self.laser:toBack()
	
	self.laser:applyLinearImpulse(150*forceMag*self.xComp, 150*forceMag*self.yComp, self.laser.x, self.laser.y)
end

function ship:breakShield()
	--print("should break the shield but for whatever reason it doesn't")
	self.shieldIsActive = false
	--print("Player1 shield: "..tostring(player1.shieldIsActive).." Player2 shield: "..tostring(player2.shieldIsActive))
	self.shield.alpha = 0
	self.shield.xScale = 0.1
	self.shield.yScale = 0.1
	--timer.performWithDelay( 20000, self:restoreShield())
	self:restoreShield()
	
end

function ship:restoreShield()
	transition.to(self.shield, {time = 7000, alpha = 0.5, xScale = 1, yScale = 1, onComplete = function() self.shieldIsActive = true end})
	
end

function explosion(xCoord, yCoord)
	exp = display.newImage(mainGroup, objectSheet15, 0, xCoord, yCoord)
	exp.alpha = 0
	exp:scale(0.1,0.1)
	exp.rotation = math.random(360)
	transition.to( exp, {time = 250, alpha = 1, xScale = 0.7, yScale = 0.7} )
	transition.to( exp, {delay = 250, time = 250, alpha = 0, onComplete = function()display.remove(exp)end})
end

local function updateText()
	explode = true
	playerLivesText.text = "Player 1 Lives: ".. player1.lives
	player1LivesText.text = "Player 2 Lives: ".. player2.lives
end

local function createAsteroid()
	local newAsteroid = display.newImage(mainGroup, objectSheet5,80,80)
	newAsteroid:scale(0.25,0.25)
	--table.insert(objectTable, newAsteroid)
	table.insert(asteroidsTable, newAsteroid)
	physics.addBody(newAsteroid,"dynamic", { radius = 65, bounce = 0.5})
	newAsteroid.name = "asteroid"
	newAsteroid.type = "asteroid"
	newAsteroid.health = 3
	newAsteroid.hit = false
	local whereFrom = math.random(4)
	--asteroidCount = asteroidCount + 1
		--newAsteroid.alpha = 0
		--spawnAsteroid()
	if (whereFrom == 1) then
		--From the Left

		newAsteroid.x = -60
		newAsteroid.y = math.random(display.contentHeight)
		newAsteroid:setLinearVelocity(math.random(20,120),math.random(20,60))
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

local function makeAsteroidBumpers()
	local fudgeNum = 150 + 2 -- extra positioning when rock is moved
	
	asteroidBumper["top"] = display.newRect( display.contentWidth/2, 0 - fudgeNum*1.5, display.contentWidth + fudgeNum *2, fudgeNum )	
	asteroidBumper["top"].type = "asteroidBumper"
	asteroidBumper["top"].name = "top"
	asteroidBumper["top"].opposite = "bottom"
	asteroidBumper["top"].fudge = -fudgeNum
	physics.addBody( asteroidBumper["top"], "static", { isSensor=true } )

	asteroidBumper["left"] = display.newRect( 0 - fudgeNum*1.5, display.contentHeight/2, fudgeNum, display.contentHeight + fudgeNum*2 )
	asteroidBumper["left"].type = "asteroidBumper"
	asteroidBumper["left"].name = "left"
	asteroidBumper["left"].opposite = "right"
	asteroidBumper["left"].fudge = -fudgeNum
	physics.addBody( asteroidBumper["left"], "static", { isSensor=true } )

	asteroidBumper["bottom"] = display.newRect( display.contentWidth/2, display.contentHeight + fudgeNum*1.5, display.contentWidth + fudgeNum * 2, fudgeNum )
	asteroidBumper["bottom"].type = "asteroidBumper"
	asteroidBumper["bottom"].name = "bottom"
	asteroidBumper["bottom"].opposite = "top"
	asteroidBumper["bottom"].fudge = fudgeNum
	physics.addBody( asteroidBumper["bottom"], "static", { isSensor=true } )

	asteroidBumper["right"] = display.newRect( display.contentWidth + fudgeNum*1.5, display.contentHeight/2, fudgeNum, display.contentHeight+fudgeNum*2 )
	asteroidBumper["right"].type = "asteroidBumper"
	asteroidBumper["right"].name = "right"
	asteroidBumper["right"].opposite = "left"
	asteroidBumper["right"].fudge = fudgeNum
	physics.addBody( asteroidBumper["right"], "static", { isSensor=true } )
end

local function makeOtherBumpers()
	local fudgeNum = 53 + 2 -- extra positioning when rock is moved
	
	otherBumper["top"] = display.newRect( display.contentWidth/2, 0 - fudgeNum, display.contentWidth + fudgeNum *2, fudgeNum )	
	otherBumper["top"].type = "otherBumper"
	otherBumper["top"].name = "top"
	otherBumper["top"].opposite = "bottom"
	otherBumper["top"].fudge = -fudgeNum
	physics.addBody( otherBumper["top"], "static", { isSensor=true } )

	otherBumper["left"] = display.newRect(0 - fudgeNum*1.5, display.contentHeight/2, fudgeNum, display.contentHeight + fudgeNum*2  )
	otherBumper["left"].type = "otherBumper"
	otherBumper["left"].name = "left"
	otherBumper["left"].opposite = "right"
	otherBumper["left"].fudge = -fudgeNum
	physics.addBody( otherBumper["left"], "static", { isSensor=true } )

	otherBumper["bottom"] = display.newRect( display.contentWidth/2, display.contentHeight + fudgeNum, display.contentWidth + fudgeNum * 2, fudgeNum )
	otherBumper["bottom"].type = "otherBumper"
	otherBumper["bottom"].name = "bottom"
	otherBumper["bottom"].opposite = "top"
	otherBumper["bottom"].fudge = fudgeNum
	physics.addBody( otherBumper["bottom"], "static", { isSensor=true } )

	otherBumper["right"] = display.newRect( display.contentWidth + fudgeNum, display.contentHeight/2, fudgeNum, display.contentHeight+fudgeNum*2 )
	otherBumper["right"].type = "otherBumper"
	otherBumper["right"].name = "right"
	otherBumper["right"].opposite = "left"
	otherBumper["right"].fudge = fudgeNum
	physics.addBody( otherBumper["right"], "static", { isSensor=true } )	
end

local function makeLaserBumpers()
	local fudgeNum = 0 + 2 --93 + 2 
	
	laserBumper["top"] = display.newRect( display.contentWidth/2, 0 - fudgeNum*1.5, display.contentWidth + fudgeNum *2, fudgeNum )	
	laserBumper["top"].type = "laserBumper"
	laserBumper["top"].name = "top"
	laserBumper["top"].opposite = "bottom"
	laserBumper["top"].fudge = -fudgeNum
	physics.addBody( laserBumper["top"], "static", { isSensor=true } )

	laserBumper["left"] = display.newRect( 0 - fudgeNum*1.5, display.contentHeight/2, fudgeNum, display.contentHeight + fudgeNum*2 )
	laserBumper["left"].type = "laserBumper"
	laserBumper["left"].name = "left"
	laserBumper["left"].opposite = "right"
	laserBumper["left"].fudge = -fudgeNum
	physics.addBody( laserBumper["left"], "static", { isSensor=true } )

	laserBumper["bottom"] = display.newRect( display.contentWidth/2, display.contentHeight + fudgeNum*1.5, display.contentWidth + fudgeNum * 2, fudgeNum )
	laserBumper["bottom"].type = "laserBumper"
	laserBumper["bottom"].name = "bottom"
	laserBumper["bottom"].opposite = "top"
	laserBumper["bottom"].fudge = fudgeNum
	physics.addBody( laserBumper["bottom"], "static", { isSensor=true } )

	laserBumper["right"] = display.newRect( display.contentWidth + fudgeNum*1.5, display.contentHeight/2, fudgeNum, display.contentHeight+fudgeNum*2 )
	laserBumper["right"].type = "laserBumper"
	laserBumper["right"].name = "right"
	laserBumper["right"].opposite = "left"
	laserBumper["right"].fudge = fudgeNum
	physics.addBody( laserBumper["right"], "static", { isSensor=true } )
end

local function garbageCollector()
	--print("In garbageCollector")
	for i = 1, #objectTable, 1 do
		stray = objectTable[i]
		if (stray ~= nil and ((stray.x < -200) or (stray.x > display.contentWidth + 200) or (stray.y < -200) or (stray.y > display.contentHeight + 200))) then
			display.remove(stray)
			table.remove(objectTable, i)
			stray = 0
			--print(stray)
			--print("cleaned up: "..i)
		end
	end
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
				if(thisPlayer.died == false and thisPlayer.energy > 0) then
					thisPlayer:fire()
					event.device:vibrate()
				end
			end
		end
	end
end

Runtime:addEventListener( "key", onKeyEvent )

local function onAxisEvent(event)
	if(player1.lives > 0 and player2.lives > 0) then
		if(math.abs(event.normalizedValue) > 0.15) then
			--print("Gamepad: "..event.device.descriptor.."Axis: "..event.axis.number.." Value: "..event.normalizedValue)
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
	    		if(thisPlayer.died == false and thisPlayer.energy > 0) then
					thisPlayer:fire()
					event.device:vibrate()
				end
			end
			thisPlayer.prevValue = event.normalizedValue
		end
	end
end
Runtime:addEventListener( "axis", onAxisEvent )

local function onFrameEvent()
	p1 = true
	p2 = true

	--player lives update
	if(player1.body.health < 1) then
		player1.healthBar4.alpha = 0
	elseif(player1.body.health < 2) then
		player1.healthBar2.alpha = 0
	elseif(player1.body.health < 3) then
		player1.healthBar3.alpha = 0
	elseif(player1.body.health < 4) then
		player1.healthBar4.alpha = 0
	end

	if(player2.body.health < 1) then
		player2.healthBar4.alpha = 0
	elseif(player2.body.health < 2) then
		player2.healthBar2.alpha = 0
	elseif(player2.body.health < 3) then
		player2.healthBar3.alpha = 0
	elseif(player2.body.health < 4) then
		player2.healthBar4.alpha = 0
	end

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
	counter = counter + 1
	if (counter == 20) then
		counter = 0
		garbageCollector()
	end

	--	Create new asteroid
		if (#asteroidsTable < 5) then
			createAsteroid()
		end
		if (player1.energy <= 5) then
			player1.energy = player1.energy + 1
		end
		if (player2.energy <= 5) then
			player2.energy = player2.energy + 1
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
				if(player1.lives > 0) then
					player1.body:setLinearVelocity(0,0)
					player1.push = false
					player1.body.isBodyActive = true
					player1.died = false
					player1.body.health = 4
					player1.energy = 5
					player1:restoreShield()
					player1.healthBar.alpha = 1
					player1.healthBar1.alpha = 1
					player1.healthBar2.alpha = 1
					player1.healthBar3.alpha = 1
					player1.healthBar4.alpha = 1
				end
			end
		} )
	end
end

local function restoreShip2()
	if(player2.lives > 0) then			
		--player2.body.isBodyActive = false
		player2.body.x = math.random(1300,1800)
		player2.body.y = math.random(400,900)

		-- Fade in the ship
		transition.to( player2.body, { alpha=1, time=1000,
			onComplete = function()
				if(player1.lives > 0) then
					player2.body:setLinearVelocity(0,0)
					player2.push = false
					player2.body.isBodyActive = true
					player2.died = false
					player2.body.health = 4
					player2.energy = 5
					player2:restoreShield()
					player2.healthBar.alpha = 1
					player2.healthBar1.alpha = 1
					player2.healthBar2.alpha = 1
					player2.healthBar3.alpha = 1
					player2.healthBar4.alpha = 1
				end
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

		--Asteroid Bumper
		if (obj1.type == "asteroidBumper" and obj2.type == "asteroid") then
        	--print("asteroid bumper")
        	local function wrap()
        		if obj1.name == "left" or obj1.name == "right" then
	        		obj2.x = asteroidBumper[obj1.opposite].x + obj1.fudge
	        	else
	        		obj2.y = asteroidBumper[obj1.opposite].y + obj1.fudge
        		end
        	end
        	timer.performWithDelay ( 1, wrap )
		
		--Laser Bumper
		elseif(obj1.type == "laserBumper" and (obj2.type == "laser")) then
			local function wrap()
				if (obj2.movedHorizontal == false and (obj1.name == "left" or obj1.name == "right")) then
					obj2.x = laserBumper[obj1.opposite].x + obj1.fudge
					obj2.movedHorizontal = true
				elseif (obj2.movedVertical == false and (obj1.name == "top" or obj1.name == "bottom")) then
					obj2.y = laserBumper[obj1.opposite].y + obj1.fudge
					obj2.movedVertical = true
				end
			end
			timer.performWithDelay( 1,wrap )

		--Ship and Small Asteorid Bumper
		elseif (obj1.type == "otherBumper" and (obj2.type == "ship" or obj2.name == "smallAsteroid")) then
        	local function wrap()
        		if (obj2.type == "ship") then
        			--print(obj2.x.." "..obj2.y)
        		end
        		if obj1.name == "left" or obj1.name == "right" then
	        		obj2.x = otherBumper[obj1.opposite].x + obj1.fudge
	        		--print("ship horizontal")
	        	else
	        		obj2.y = otherBumper[obj1.opposite].y + obj1.fudge
	        		--print("ship vertical")
        		end
        	end
        	timer.performWithDelay ( 1, wrap )
        	
        --Laser on Asteroid
		elseif ((obj1.type == "laser" and obj2.name == "asteroid" and obj2.hit == false) or
				(obj1.name == "asteroid" and obj1.hit == false and obj2.type =="laser")) then
			obj1.hit = true
			obj2.hit = true
			if (obj1.type ~= "laser") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			display.remove(obj1)
			obj1.isBodyActive = false
			local function hit()
				obj2.hit = false
				for i = #objectTable, 1, -1 do
					if objectTable[i] == obj1 then
						table.remove(objectTable, i)
						obj1 = nil
					end
				end
				for i = #asteroidsTable, 1, -1 do
					if ( asteroidsTable[i] == obj2)  then
						obj2.health = obj2.health - 1
						if (obj2.health <= 0) then
							explosion(obj2.x,obj2.y)
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet5,1,80,80)
								newSmallAsteroid:scale(0.07,0.07)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.hit = false
								newSmallAsteroid.x, newSmallAsteroid.y = obj2:localToContent(40,40) --+ (math.random(-20,20))
								newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
								newSmallAsteroid:applyTorque(-0.1,0.1)
								newSmallAsteroid.newSpawn = true
								local function spawnIn()
									newSmallAsteroid.newSpawn = false
								end
								timer.performWithDelay(100,spawnIn)
							end
							table.remove( asteroidsTable, i )
							display.remove(obj2)
							for i = 1, 3, 1 do
								spawnSmallAsteroid()
							end
						end
					end
				end

			end
			timer.performWithDelay(1,hit)


		--Laser on Small Asteroid
		elseif ((obj1.type == "laser" and obj2.type == "smallAsteroid" and obj2.hit == false) or 
				(obj1.type == "smallAsteroid" and obj1.hit == false and obj2.type == "laser")) then
			if (obj1.type ~= "smallAsteroid") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			display.remove(obj1)
			obj1.hit = true
			obj1.isBodyActive = false
			obj1 = nil
			for i = #objectTable, 1, -1 do
				if (objectTable[i] == obj2) then
					display.remove(obj2) 
					table.remove(objectTable, i)
					obj2 = nil
					break
				end
			end


		--Asteroid on Small Asteroid
		elseif 	((obj1.name == "asteroid" and obj1.hit == false and obj2.name == "smallAsteroid" and obj2.hit == false) or
				(obj1.name == "smallAsteroid" and obj1.hit == false and obj2.name == "asteroid" and obj2.hit == false)) then
			obj1.hit = true
			obj2.hit = true
			if (obj1.name ~= "asteroid") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			obj2.isBodyActive = false
			display.remove(obj2)
			obj2 = nil
			local function hit()
				obj1.hit = false
				local colliseChannel = audio.play( asteroidcollideChannel, { channel=7 } )
				audio.setVolume( 1.0, { channel=7 } )
				for i = #asteroidsTable, 1, -1 do
					if ( asteroidsTable[i] == obj1) then
						obj1.health = obj1.health - 1
						if (obj1.health <= 0) then
							explosion(obj1.x,obj1.y)
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet5,1,80,80)
								newSmallAsteroid:scale(0.07,0.07)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.hit = false
								newSmallAsteroid.x, newSmallAsteroid.y = obj1:localToContent(40,40) --+ (math.random(-20,20))
								newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
								newSmallAsteroid:applyTorque(-0.1,0.1)
								newSmallAsteroid.newSpawn = true
								local function spawnIn()
									newSmallAsteroid.newSpawn = false
								end
								timer.performWithDelay(100,spawnIn)
							end
							table.remove( asteroidsTable, i )
							display.remove(obj1)
							for i = 1, 3, 1 do
								spawnSmallAsteroid()
							end
						end
					end
				end
			end
			timer.performWithDelay(1,hit)

		--Asteroid on Asteroid
		elseif ((obj1.name == "asteroid" and obj1.hit == false) and (obj2.name == "asteroid" and obj2.hit == false)) then
			obj1.hit = true
			obj2.hit = true
			local function hit()
				obj1.hit = false
				obj2.hit = false
				local colliseChannel = audio.play( asteroidcollideChannel, { channel=7 } )
					audio.setVolume( 1.0, { channel=7 } )
				for i = #asteroidsTable, 1, -1 do
					if ( asteroidsTable[i] == obj1 ) then
						obj1.health = obj1.health - 1
						if (obj1.health <= 0) then
							explosion(obj1.x,obj1.y)
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet5,1,80,80)
								newSmallAsteroid:scale(0.07,0.07)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.hit = false
								newSmallAsteroid.x, newSmallAsteroid.y = obj1:localToContent(40,40) --+ (math.random(-20,20))
								newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
								newSmallAsteroid:applyTorque(-0.1,0.1)
								newSmallAsteroid.newSpawn = true
								local function spawnIn()
									newSmallAsteroid.newSpawn = false
								end
								timer.performWithDelay(100,spawnIn)
							end
							table.remove( asteroidsTable, i )
							display.remove(obj1)
							for i = 1, 3, 1 do
								spawnSmallAsteroid()
							end
						end
					end
					if ( asteroidsTable[i] == obj2 ) then
						obj2.health = obj2.health - 1
						if (obj2.health <= 0) then
							explosion(obj2.x,obj2.y)
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet5,1,80,80)
								newSmallAsteroid:scale(0.07,0.07)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.hit = false
								newSmallAsteroid.x, newSmallAsteroid.y = obj2:localToContent(40,40) --+ (math.random(-20,20))
								newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
								newSmallAsteroid:applyTorque(-0.1,0.1)
								newSmallAsteroid.newSpawn = true
								local function spawnIn()
									newSmallAsteroid.newSpawn = false
								end
								timer.performWithDelay(100,spawnIn)
							end
							table.remove( asteroidsTable, i )
							display.remove(obj2)
							for i = 1, 3, 1 do
								spawnSmallAsteroid()
							end
						end
					end
				end
			end
			timer.performWithDelay(1,hit)

		--Small Asteroid on Small Asteroid
		elseif ((obj1.name == "smallAsteroid" and obj1.newSpawn == false and obj1.hit == false) and (obj2.name == "smallAsteroid" and obj2.newSpawn == false and obj2.hit == false)) then
			obj1.hit = true
			obj2.hit = true
			local function collision()
				display.remove(obj1)
				display.remove(obj2)
				obj1.isBodyActive = false
				obj2.isBodyActive = false
				obj1 = nil
				obj2 = nil
			end
			timer.performWithDelay(1, collision)

		--Ship on Ship
		elseif ((obj1.type == "ship" and obj1.hit == false) and (obj2.type == "ship" and obj2.hit == false)) then
			obj1.hit = true
			obj2.hit = true
			local function collision()
				if (obj1.name ~= "ship1") then
					obj3 = obj1
					obj1 = obj2
					obj2 = obj3
					obj3 = nil
				end
				obj1.hit = false
				obj2.hit = false
				obj1.health = obj1.health -1
				if (obj1.health <= 0) then
					player1.died = true

					player1.lives = player1.lives - 1
					playerLivesText.text = "Player 1 Lives: " .. player1.lives
					if ( player1.lives <= 0 ) then
						local explosionChannel1 = audio.play( explosionChannel, { channel=6 } )
						audio.setVolume( 1.0, { channel=6 } )
						display.remove( player1.body )
						display.remove( player1.healthBar )
						display.remove( player1.healthBar1 )
						display.remove( player1.healthBar2 )
						display.remove( player1.healthBar3 )
						display.remove( player1.healthBar4 )
						display.remove( player1.shield )
						display.remove( player2.body )
						display.remove( player2.healthBar )
						display.remove( player2.healthBar1 )
						display.remove( player2.healthBar2 )
						display.remove( player2.healthBar3 )
						display.remove( player2.healthBar4 )
						display.remove( player2.shield )
						timer.performWithDelay( 4000, endGame )
					else
						player1.healthBar.alpha = 0
						player1.healthBar1.alpha = 0
						player1.healthBar2.alpha = 0
						player1.healthBar3.alpha = 0
						player1.healthBar4.alpha = 0
						player1.shield.alpha = 0
						player1.body.alpha = 0
						player1.body.isBodyActive = false
						timer.performWithDelay( 1000, restoreShip1 )
					end
				end

				obj2.health = obj2.health -1
				if (obj2.health <= 0) then
					player2.died = true
					
					player2.lives = player2.lives - 1
					player1LivesText.text = "Player 2 Lives: " .. player2.lives
					if ( player2.lives <= 0 ) then
						local explosionChannel2 = audio.play( explosionChannel, { channel=6 } )
						audio.setVolume( 1.0, { channel=6 } )
						display.remove( player1.body )
						display.remove( player1.healthBar )
						display.remove( player1.healthBar1 )
						display.remove( player1.healthBar2 )
						display.remove( player1.healthBar3 )
						display.remove( player1.healthBar4 )
						display.remove( player1.shield )
						display.remove( player2.body )
						display.remove( player2.healthBar )
						display.remove( player2.healthBar1 )
						display.remove( player2.healthBar2 )
						display.remove( player2.healthBar3 )
						display.remove( player2.healthBar4 )
						display.remove( player2.shield )
						timer.performWithDelay( 4000, endGame )
					else
						player2.healthBar.alpha = 0
						player2.healthBar1.alpha = 0
						player2.healthBar2.alpha = 0
						player2.healthBar3.alpha = 0
						player2.healthBar4.alpha = 0
						player2.shield.alpha = 0
						player2.body.alpha = 0
						player2.body.isBodyActive = false
						timer.performWithDelay( 1000, restoreShip2 )
					end
				end
			end
			timer.performWithDelay(100,collision)
				
			if (player1.lives == 0 or player2.lives == 0) then
				if (player1.lives > player2.lives) then
					winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
				elseif (player1.lives < player2.lives) then
					winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
				else
					winnerText = display.newText( uiGroup, "DRAW", display.contentWidth/2, 150, native.systemFont, 30 )
				end
			end
		
		--Start here like
		elseif((obj1.name == "ship2" and obj1.hit == false and obj2.name == "laser1") or
			(obj1.name == "laser1" and obj2.name == "ship2" and obj2.hit == false)) then
			if (obj1.name ~= "ship2") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			obj2.isBodyActive = false
			obj1.hit = true
			local function hit()
				obj1.hit = false
				for i = #objectTable, 1, -1 do
					if objectTable[i] == obj2 then
						table.remove(objectTable, i)
						display.remove(obj2)
						obj2 = nil
					end
				end
				if(player2.shieldIsActive == false) then
					obj1.health = obj1.health - 1
					if (obj1.health <= 0) then
						player2.died = true
						player2.lives = player2.lives - 1
						player1LivesText.text = "Player 2 Lives: " .. player2.lives

						explosion(player2.body.x, player2.body.y)

						if ( player2.lives == 0 ) then
							display.remove( player2.body )
							display.remove( player2.healthBar )
							display.remove( player2.healthBar1 )
							display.remove( player2.healthBar2 )
							display.remove( player2.healthBar3 )
							display.remove( player2.healthBar4 )
							display.remove( player2.shield )
							winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( player1.body )
							display.remove( player1.healthBar )
							display.remove( player1.healthBar1 )
							display.remove( player1.healthBar2 )
							display.remove( player1.healthBar3 )
							display.remove( player1.healthBar4 )
							display.remove( player1.shield )
							timer.performWithDelay( 4000, endGame )
						else
							player2.healthBar.alpha = 0
							player2.healthBar1.alpha = 0
							player2.healthBar2.alpha = 0
							player2.healthBar3.alpha = 0
							player2.healthBar4.alpha = 0
							player2.shield.alpha = 0
							player2.body.alpha = 0
							player2.body.isBodyActive = false
							timer.performWithDelay( 1000, restoreShip2 )
						end
					end
				else
					player2:breakShield()
				end
			end
			timer.performWithDelay(1,hit)

		elseif((obj1.name == "ship1" and obj1.hit == false and obj2.name == "laser2") or
			(obj1.name == "laser2" and obj2.name == "ship1" and obj2.hit == false)) then
			if (obj1.name ~= "ship1") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			obj2.isBodyActive = false
			obj1.hit = true
			local function hit()
				obj1.hit = true
				for i = #objectTable, 1, -1 do
					if objectTable[i] == obj2 then
						table.remove(objectTable, i)
						display.remove(obj2)
						obj2 = nil
					end
				end
				if(player1.shieldIsActive == false) then
					obj1.health = obj1.health - 1
					if (obj1.health <= 0) then
						player1.died = true
						player1.lives = player1.lives - 1
						playerLivesText.text = "Player 1 Lives: " .. player1.lives

						explosion(player1.body.x, player1.body.y)

						if ( player1.lives == 0 ) then
							display.remove( player2.body )
							display.remove( player2.healthBar )
							display.remove( player2.healthBar1 )
							display.remove( player2.healthBar2 )
							display.remove( player2.healthBar3 )
							display.remove( player2.healthBar4 )
							display.remove( player2.shield )
							winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( player1.body )
							display.remove( player1.healthBar )
							display.remove( player1.healthBar1 )
							display.remove( player1.healthBar2 )
							display.remove( player1.healthBar3 )
							display.remove( player1.healthBar4 )
							display.remove( player1.shield )
							timer.performWithDelay( 4000, endGame )
						else
							player1.healthBar.alpha = 0
							player1.healthBar1.alpha = 0
							player1.healthBar2.alpha = 0
							player1.healthBar3.alpha = 0
							player1.healthBar4.alpha = 0
							player1.shield.alpha = 0
							player1.body.alpha = 0
							player1.isBodyActive = false
							timer.performWithDelay( 1000, restoreShip1 )
						end
					end
				else
					player1:breakShield()
				end
			end
			timer.performWithDelay(1,hit)

		elseif((obj1.type == "ship" and obj1.hit == false and obj2.name == "smallAsteroid") or 
			(obj1.name == "smallAsteroid" and obj2.type == "ship" and obj2.hit == false)) then
			if (obj1.type ~= "ship") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			obj1.hit = true
			display.remove(obj2)
			obj2.isBodyActive = false
			obj2 = nil
			local function hit()
				obj1.hit = false
				if (obj1.name == "ship1") then
					obj1.health = obj1.health - 1
					if (obj1.health <= 0) then
						player1.died = true
						player1.lives = player1.lives - 1
						playerLivesText.text = "Player 1 Lives: " .. player1.lives

						explosion(player1.body.x, player1.body.y)

						if ( player1.lives == 0 ) then
							display.remove( player2.body )
							display.remove( player2.healthBar )
							display.remove( player2.healthBar1 )
							display.remove( player2.healthBar2 )
							display.remove( player2.healthBar3 )
							display.remove( player2.healthBar4 )
							display.remove( player2.shield )
							winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( player1.body )
							display.remove( player1.healthBar )
							display.remove( player1.healthBar1 )
							display.remove( player1.healthBar2 )
							display.remove( player1.healthBar3 )
							display.remove( player1.healthBar4 )
							display.remove( player1.shield )
							timer.performWithDelay( 4000, endGame )
						else
							player1.healthBar.alpha = 0
							player1.healthBar1.alpha = 0
							player1.healthBar2.alpha = 0
							player1.healthBar3.alpha = 0
							player1.healthBar4.alpha = 0
							player1.shield.alpha = 0
							player1.body.alpha = 0
							player1.isBodyActive = false
							timer.performWithDelay( 1000, restoreShip1 )
						end
					end
				elseif (obj1.name == "ship2") then
					obj1.health = obj1.health -1
					if(obj1.health <= 0) then
						player2.died = true
						player2.lives = player2.lives - 1
						player1LivesText.text = "Player 2 Lives: " .. player2.lives

						explosion(player2.body.x, player2.body.y)

						if ( player2.lives == 0 ) then
							display.remove( player2.body )
							display.remove( player2.healthBar )
							display.remove( player2.healthBar1 )
							display.remove( player2.healthBar2 )
							display.remove( player2.healthBar3 )
							display.remove( player2.healthBar4 )
							display.remove( player2.shield )
							winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( player1.body )
							display.remove( player1.healthBar )
							display.remove( player1.healthBar1 )
							display.remove( player1.healthBar2 )
							display.remove( player1.healthBar3 )
							display.remove( player1.healthBar4 )
							display.remove( player1.shield )
							timer.performWithDelay( 4000, endGame )
						else
							player2.healthBar.alpha = 0
							player2.healthBar1.alpha = 0
							player2.healthBar2.alpha = 0
							player2.healthBar3.alpha = 0
							player2.healthBar4.alpha = 0
							player2.shield.alpha = 0
							player2.body.alpha = 0
							player2.isBodyActive = false
							timer.performWithDelay( 1000, restoreShip2 )
						end 
					end
				end
			end
			timer.performWithDelay(1,hit)
			
		elseif((obj1.type == "ship" and obj1.hit == false and obj2.name == "asteroid" and obj2.hit == false) or 
			(obj1.name == "asteroid" and obj1.hit == false and obj2.type == "ship" and obj2.hit == false)) then
			if (obj1.type ~= "ship") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			obj1.hit = true
			obj2.hit = true
			local function hit()
				obj1.hit = false
				obj2.hit = false
				for i = #asteroidsTable, 1, -1 do
					if ( asteroidsTable[i] == obj2) then
						asteroidHit = true
						obj2.health = obj2.health - 1
						if (obj2.health <= 0) then
							explosion(obj2.x,obj2.y)
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet5,1,80,80)
								newSmallAsteroid:scale(0.07,0.07)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.hit = false
								newSmallAsteroid.x, newSmallAsteroid.y = obj2:localToContent(40,40) --+ (math.random(-20,20))
								newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
								newSmallAsteroid:applyTorque(-0.1,0.1)
								newSmallAsteroid.newSpawn = true
								local function spawnIn()
									newSmallAsteroid.newSpawn = false
								end
								timer.performWithDelay(100,spawnIn)
							end
							table.remove( asteroidsTable, i )
							display.remove(obj2)
							for i = 1, 3, 1 do
								spawnSmallAsteroid()
							end
						end
					end
				end
				if (obj1.name == "ship1") then
					obj1.health = obj1.health - 1
					if (obj1.health <= 0) then
						player1.died = true
						player1.lives = player1.lives - 1
						playerLivesText.text = "Player 1 Lives: " .. player1.lives

						explosion(player1.body.x, player1.body.y)

						if ( player1.lives == 0 ) then
							display.remove( player2.body )
							display.remove( player2.healthBar )
							display.remove( player2.healthBar1 )
							display.remove( player2.healthBar2 )
							display.remove( player2.healthBar3 )
							display.remove( player2.healthBar4 )
							display.remove( player2.shield )
							winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( player1.body )
							display.remove( player1.healthBar )
							display.remove( player1.healthBar1 )
							display.remove( player1.healthBar2 )
							display.remove( player1.healthBar3 )
							display.remove( player1.healthBar4 )
							display.remove( player1.shield )
							timer.performWithDelay( 4000, endGame )
						else
							player1.healthBar.alpha = 0
							player1.healthBar1.alpha = 0
							player1.healthBar2.alpha = 0
							player1.healthBar3.alpha = 0
							player1.healthBar4.alpha = 0
							player1.shield.alpha = 0
							player1.body.alpha = 0
							player1.isBodyActive = false
							timer.performWithDelay( 1000, restoreShip1 )
						end
					end
				elseif (obj1.name == "ship2") then
					obj1.health = obj1.health -1
					if(obj1.health <= 0) then
						player2.died = true
						player2.lives = player2.lives - 1
						player1LivesText.text = "Player 2 Lives: " .. player2.lives

						explosion(player2.body.x, player2.body.y)

						if ( player2.lives == 0 ) then
							display.remove( player2.body )
							display.remove( player2.healthBar )
							display.remove( player2.healthBar1 )
							display.remove( player2.healthBar2 )
							display.remove( player2.healthBar3 )
							display.remove( player2.healthBar4 )
							display.remove( player2.shield )
							winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( player1.body )
							display.remove( player1.healthBar )
							display.remove( player1.healthBar1 )
							display.remove( player1.healthBar2 )
							display.remove( player1.healthBar3 )
							display.remove( player1.healthBar4 )
							display.remove( player1.shield )
							timer.performWithDelay( 4000, endGame )
						else
							player2.healthBar.alpha = 0
							player2.healthBar1.alpha = 0
							player2.healthBar2.alpha = 0
							player2.healthBar3.alpha = 0
							player2.healthBar4.alpha = 0
							player2.shield.alpha = 0
							player2.body.alpha = 0
							player2.isBodyActive = false
							timer.performWithDelay( 1000, restoreShip2 )
						end 
					end
				end
			end
		timer.performWithDelay(1,hit)
		--ship2 hit by smallAsteroid
		--ship1 hit by asteroid
		--ship2 hit by asteroid
		--else
			--print("Unknown collision between Obj1: ".. obj1.name .." and Obj2: "..obj2.name)
		end
	end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()	
	local backgroundMusicChannel = audio.play( backgroundMusicChannel, { channel=1, loops=-1, fadein=1000 } )
	audio.setVolume( 1.0, { channel=1 } )

function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	audio.fadeOut( { channel=2, time=2000 } )

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

	makeAsteroidBumpers()
	makeOtherBumpers()
	makeLaserBumpers()

	player1 = ship.new("ship1")
	player2 = ship.new("ship2")


	playerLivesText = display.newText(uiGroup, "Player 1 Lives: ".. player1.lives, 100, 20, native.SystemFont, 20)
	player1LivesText = display.newText(uiGroup, "Player 2 Lives: ".. player2.lives, display.contentWidth - 100, 20, native.SystemFont, 20)

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
		audio.fadeOut( { channel=1, time=5000 } )
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
