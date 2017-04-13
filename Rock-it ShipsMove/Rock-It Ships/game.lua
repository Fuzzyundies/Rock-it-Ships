
local composer = require( "composer" )

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


local objectSheet2 = graphics.newImageSheet("gameObjects2.png", sheetOptions)

local lives1 = 3
local lives2 = 3
local died1 = false
local died2 = false

local ship1
local ship2
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

local function updateText()
	lives1Text.text = "Player 1 Lives: ".. lives1
	lives2Text.text = "Player 2 Lives: ".. lives2
end

local function createAsteroid()
		local newAsteroid = display.newImage(mainGroup, objectSheet,1,102,85)
		table.insert(asteroidsTable, newAsteroid)
		physics.addBody(newAsteroid,"dynamic", { radius = 40, bounce = 0.8})
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

local function fireLaser1()
	local laser1 = display.newImage( mainGroup, objectSheet, 5, 98, 40 )
	physics.addBody( laser1, "dynamic", { isSensor=true } )
	laser1.isBullet = true
	laser1:rotate(90)
	laser1.myName = "laser1"

	laser1.x = ship1.x
	laser1.y = ship1.y + 40
	laser1:toBack()

	laser1:setLinearVelocity(1000,0)
	--print("Still not Firing")
end

local function fireLaser2()

	local laser2 = display.newImage( mainGroup, objectSheet2, 5, 98, 40 )
	physics.addBody( laser2, "dynamic", { isSensor=true } )
	laser2.isBullet = true
	laser2:rotate(-90)
	laser2.myName = "laser2"

	laser2.x = ship2.x
	laser2.y = ship2.y - 40
	laser2:toBack()
	
	laser2:setLinearVelocity(-1000,0)
end

local function onKeyEvent(event)
	local message = "Device " ..event.device.descriptor.. " key '" .. event.keyName .. "' was pressed " .. event.phase
	local thisPlayer
 
    if ( event.device.descriptor == "Gamepad 1" ) then
        thisPlayer = ship1
    else
        thisPlayer = ship2
    end
    print( message )
	if(event.keyName == "rightShoulderButton1" and event.phase == "down") then
		if(thisPlayer == ship1)then
			--print("Not Firing")
			fireLaser1()
		else
			fireLaser2()
		end
	end
end

local function gameLoop()

	-- Create new asteroid
		if (asteroidCount <= 10) then
			createAsteroid()
		end
	-- Remove asteroids which have drifted off screen
	--[[for i = #asteroidsTable, 1, -1 do
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
	end]]--
end

local function restoreShip1()

	ship1.isBodyActive = false
	--ship1.x = display.contentWidth - 470
	--ship1.y = display.contentCenterY 

	-- Fade in the ship
	transition.to( ship1, { alpha=1, time=1000,
		onComplete = function()
			ship1.isBodyActive = true
			died1 = false
		end
	} )
end

local function restoreShip2()

	ship2.isBodyActive = false
	--ship2.x = display.contentWidth - 10
	--ship2.y = display.contentCenterY 

	-- Fade in the ship
	transition.to( ship2, { alpha=1, time=1000,
		onComplete = function()
			ship2.isBodyActive = true
			died2 = false
		end
	} )
end

local function endGame()
	composer.gotoScene( "menu" )
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
			if ( died1 == false ) then
				died1 = true

				-- Update lives
				lives1 = lives1 - 1
				lives1Text.text = "Player 1 Lives: " .. lives1

				if ( lives1 == 0 ) then
					display.remove( ship1 )
					winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
					display.remove( ship2 )
					timer.performWithDelay( 20000, endGame )
				else
					ship1.alpha = 0
					timer.performWithDelay( 1000, restoreShip1 )
				end
			end
				
		elseif ( ( obj1.myName == "ship2" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship2" )  or
				 ( obj1.myName == "laser1" and obj2.myName == "ship2" )  or
				 ( obj1.myName == "ship2" and obj2.myName == "laser1" ) )
		then
			if ( died2 == false ) then
				died2 = true

				-- Update lives
				lives2 = lives2 - 1
				lives2Text.text = "Player 2 Lives: " .. lives2

				if ( lives2 == 0 ) then
					display.remove( ship2 )
					winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
					display.remove( ship1 )
					timer.performWithDelay( 4000, endGame )
				else
					ship2.alpha = 0
					timer.performWithDelay( 1000, restoreShip2 )
				end
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

	local background = display.newImageRect( backGroup, "background.png", 1920, 1080 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	makeBumpers()

	lives1Text = display.newText(uiGroup, "Player 1 Lives: ".. lives1, 100, 20, native.SystemFont, 20)
	lives2Text = display.newText(uiGroup, "Player 2 Lives: ".. lives2, display.contentWidth - 100, 20, native.SystemFont, 20)

	ship1 = display.newImage(mainGroup, objectSheet, 4, 98, 79)
	ship1.x = display.contentWidth - 1820
	ship1.y = display.contentCenterY
	physics.addBody(ship1, {radius = 30, isSensor = true})
	ship1.myName = "ship1"
	ship1:rotate(90)

	ship2 = display.newImage(mainGroup, objectSheet2, 4, 98, 79)
	ship2.x = display.contentWidth - 100
	ship2.y = display.contentCenterY
	physics.addBody(ship2, {radius = 30, isSensor = true})
	ship2.myName = "ship2"
	ship2:rotate(-90)


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
