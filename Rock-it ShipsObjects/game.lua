
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local inputDevices = system.getInputDevices()

local forceMag = 0.005 
local angle1 = math.rad(90)
local xComp1 = math.cos(angle1)
local yComp1 = math.sin(angle1)
local angle2 = math.rad(-90)
local xComp2 = math.cos(angle2)
local yComp2 = math.sin(angle2)
local push1 = false
local push2 = false
 
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
			width = 9,
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

--local stray
local ship1
local ship2
local ship1Energy = 5
local ship2Energy = 5
local gameLoopTimer
local counter = 0
local lives1Text
local lives2Text
local winnerText

local reset = false

local objectTable = {}

local asteroidsTable = {}
--local asteroidCount = 0;	

local asteroidBumper = {}
local otherBumper = {}
local laserBumper = {}

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
		newAsteroid:scale(1.25,1.25)
		--table.insert(objectTable, newAsteroid)
		table.insert(asteroidsTable, newAsteroid)
		physics.addBody(newAsteroid,"dynamic", { radius = 65, bounce = 0.5})
		newAsteroid.name = "asteroid"
		newAsteroid.type = "asteroid"
		newAsteroid.health = 3
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

local function fireLaser1()
	if (ship1Energy > 0)  then
		ship1Energy = ship1Energy - 1
		angle1 = math.rad(ship1.rotation-90)
		xComp1 = math.cos(angle1)
		yComp1 = math.sin(angle1)
		local laser1 = display.newImage( mainGroup, objectSheet, 5, 49, 20 ) --98,40
		laser1:scale(0.5,0.5)
		physics.addBody( laser1, "dynamic", { isSensor=true } )
		laser1.isBullet = true
		laser1.rotation = ship1.rotation
		laser1.name = "laser1"
		laser1.movedVertical = false
		laser1.movedHorizontal = false
		table.insert(objectTable,laser1)
		laser1.x = ship1.x
		laser1.y = ship1.y
		laser1:toBack()
		laser1.type = "laser"
		
		laser1:applyLinearImpulse(100*forceMag*xComp1, 100*forceMag*yComp1, laser1.x, laser1.y)

		--[[
		local hitBox =display.newRect(mainGroup,laser1.x,laser1.y,laser1.width,laser1.height)
		hitBox.strokeWidth = 3
		hitbox.setFillColor(0,0,0,0)
		hitbox.setStrokeColor(1,0,0)
		hitBox.x = laser1.x
		hitBox.y = laser1.y
		]]
	end
end

local function fireLaser2()
	if (ship2Energy > 0) then
		ship2Energy = ship2Energy - 1
		angle2 = math.rad(ship2.rotation-90)
		xComp2 = math.cos(angle2)
		yComp2 = math.sin(angle2)
		local laser2 = display.newImage( mainGroup, objectSheet2, 5, 98, 40 )
		laser2:scale(0.5,0.5)
		physics.addBody( laser2, "dynamic", { isSensor=true } )
		laser2.isBullet = true
		laser2.rotation = ship2.rotation
		laser2.name = "laser2"
		laser2.movedVertical = false
		laser2.movedHorizontal = false
		table.insert(objectTable,laser2)
		laser2.x = ship2.x
		laser2.y = ship2.y 
		laser2:toBack()
		laser2.type = "laser"
		
		laser2:applyLinearImpulse(100*forceMag*xComp2, 100*forceMag*yComp2, laser2.x, laser2.y)
	end
end

--local motionX1 = 0
--local motionY1 = 0
local rotation1 = 0
--local motionX2 = 0
--local motionY2 = 0
local rotation2 = 0
--local movementSpeed = 3
local turningSpeed = 5
local thisPlayer
local ship1Fire = false
local ship2Fire = false
local function onKeyEvent(event)
	local message = "Device " ..event.device.descriptor.. " key '" .. event.keyName .. "' was pressed " .. event.phase
	--print(message)
    if ( event.device.descriptor == "Gamepad 1" ) then
        thisPlayer = ship1
    else
        thisPlayer = ship2
    end
    if (thisPlayer == ship1) then
	    if (event.keyName == "left" or event.keyName == "right" or event.keyName == "up" or event.keyName == "down") then
	    	if(event.phase == "down") then
				angle1 = math.rad(ship1.rotation-90)
				xComp1 = math.cos(angle1)
				yComp1 = math.sin(angle1)
				push1 = true
			else
				--[[angle1 = 0
				xComp1 = 0
				yComp1 = 0]]
				push1 = false
			end
		--[[elseif (event.keyName == "right") then
			if(event.phase == "down") then
				angle1 = math.rad(ship1.rotation-90)
				xComp1 = math.cos(angle1)
				yComp1 = -math.sin(angle1)
				push1 = true 
			else
				angle1 = 0
				xComp1 = 0
				yComp1 = 0
				push1 = false
			end
		elseif (event.keyName == "up") then
			if(event.phase == "down") then
				angle1 = math.rad(ship1.rotation)
				xComp1 = math.cos(angle1)
				yComp1 = -math.sin(angle1)
				push1 = true
			else
				angle1 = 0
				xComp1 = 0
				yComp1 = 0
				push1 = false
			end
		elseif (event.keyName == "down") then
			if(event.phase == "down") then
				angle1 = math.rad(ship1.rotation+180)
				xComp1 = math.cos(angle1)
				yComp1 = -math.sin(angle1)
				push1 = true
			else
				angle1 = 0
				xComp1 = 0
				yComp1 = 0
				push1 = true
			end]]
		end

		if (event.keyName == "buttonX") then
			if(event.phase == "down") then
				rotation1 = -turningSpeed
			else
				rotation1 = 0
			end
		elseif (event.keyName == "buttonB" ) then
			if(event.phase == "down") then
				rotation1 = turningSpeed
			else
				rotation1 = 0
			end
		end

		if (event.keyName == "rightShoulderButton1") then
			if(event.phase == "down") then
				fireLaser1()
			end
		end
	else
		if (event.keyName == "left" or event.keyName == "right" or event.keyName == "up" or event.keyName == "down") then
	    	if(event.phase == "down") then
				angle2 = math.rad(ship2.rotation-90)
				xComp2 = math.cos(angle2)
				yComp2 = math.sin(angle2)
				push2 = true
			else
				--angle2 = 0
				--xComp2 = 0
				--yComp2 = 0
				push2 = false
			end
		--[[elseif (event.keyName == "right") then
			if(event.phase == "down") then
				angle2 = math.rad(ship2.rotation+90)
				xComp2 = math.cos(angle2)
				yComp2 = -math.sin(angle2)
				push2 = true
			else
				angle2 = 0
				xComp2 = 0
				yComp2 = 0
				push2 = false
			end
		elseif (event.keyName == "up") then
			if(event.phase == "down") then
				angle2 = math.rad(ship2.rotation+90)
				xComp2 = math.cos(angle2)
				yComp2 = -math.sin(angle2)
				push2 = true
			else
				angle2 = 0
				xComp2 = 0
				yComp2 = 0
				push2 = false
			end
		elseif (event.keyName == "down") then
			if(event.phase == "down") then
				angle2 = math.rad(ship2.rotation+90)
				xComp2 = math.cos(angle2)
				yComp2 = -math.sin(angle2)
				push2 = true
			else
				angle2 = 0
				xComp2 = 0
				yComp2 = 0
				push2 = false
			end]]
		end

		if (event.keyName == "buttonX") then
			if(event.phase == "down") then
				rotation2 = -turningSpeed
			else
				rotation2 = 0
			end
		elseif (event.keyName == "buttonB" ) then
			if(event.phase == "down") then
				rotation2 = turningSpeed
			else
				rotation2 = 0
			end
		end

		if (event.keyName == "rightShoulderButton1") then
			if(event.phase == "down") then
				fireLaser2()
			end
		end
	end
end

Runtime:addEventListener( "key", onKeyEvent )
local function onFrameEvent()
local vx1, vy1 = 0
local vx2, vy2 = 0
if (lives1>0 and lives2>0) then
vx1, vy1 = ship1:getLinearVelocity()
vx2, vy2 = ship2:getLinearVelocity()
	--ship1.x = ship1.x + motionX1
	--ship1.y = ship1.y + motionY1
	ship1.rotation = ship1.rotation + rotation1
	--ship2.x = ship2.x + motionX2
	--ship2.y = ship2.y + motionY2
	ship2.rotation = ship2.rotation + rotation2
	if(push1) then
		ship1:applyLinearImpulse(forceMag*xComp1, forceMag*yComp1, ship1.x, ship1.y)
	else
		if(vx1 <= -1) then
			vx1 = vx1 + 1
		elseif(vx1 >= 1) then
			vx1 = vx1 - 1
		else
			vx1 = 0
		end
		if(vy1 <= -1) then
			vy1 = vy1 + 1
		elseif(vy1 >= 1) then
			vy1 = vy1 - 1
		else
			vy1 = 0
		end
		ship1:setLinearVelocity(vx1,vy1)
	end
	if(push2) then
		ship2:applyLinearImpulse(forceMag*xComp2, forceMag*yComp2, ship2.x, ship2.y)
	else
		if(vx2 <= -1) then
			vx2 = vx2 + 1
		elseif(vx2 >= 1) then
			vx2 = vx2 - 1
		else
			vx2 = 0
		end
		if(vy2 <= -1) then
			vy2 = vy2 + 1
		elseif(vy2 >= 1) then
			vy2 = vy2 - 1
		else
			vy2 = 0
		end
		ship2:setLinearVelocity(vx2,vy2)
		end
	end
end
Runtime:addEventListener("enterFrame", onFrameEvent)

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
		if (ship1Energy <= 5) then
			ship1Energy = ship1Energy + 1
		end
		if (ship2Energy <= 5) then
			ship2Energy = ship2Energy + 1
		end
	-- Remove asteroids which have drifted off scr
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
	ship1.x = math.random(100,500)
	ship1.y = math.random(400,900)
	ship1.health = 4

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
	ship2.x = math.random(1300,1800)
	ship2.y = math.random(400,900)
	ship2.health = 4

	-- Fade in the ship
	transition.to( ship2, { alpha=1, time=1000,
		onComplete = function()
			ship2.isBodyActive = true
			died2 = false
		end
	} )
end

local function endGame()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=800, effect="crossFade" })
end

local function onCollision( event )
	local obj1 = event.object1
	local obj2 = event.object2
	if ( event.phase == "began" ) then
		if (obj1.type == "asteroidBumper" and obj2.type == "asteroid") then
        	local function wrap()
        		if obj1.name == "left" or obj1.name == "right" then
	        		obj2.x = asteroidBumper[obj1.opposite].x + obj1.fudge
	        	else
	        		obj2.y = asteroidBumper[obj1.opposite].y + obj1.fudge
        		end
        	end
        	timer.performWithDelay ( 1, wrap )
		
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


		elseif (obj1.type == "otherBumper" and (obj2.type == "ship" or obj2.name == "smallAsteroid")) then
        	local function wrap()
        		if obj1.name == "left" or obj1.name == "right" then
	        		obj2.x = otherBumper[obj1.opposite].x + obj1.fudge
	        	else
	        		obj2.y = otherBumper[obj1.opposite].y + obj1.fudge
        		end
        	end
        	timer.performWithDelay ( 1, wrap )
        	

		elseif ((obj1.type == "laser" and obj2.name == "asteroid") or
				(obj1.name == "asteroid" and obj2.type =="laser")) then
			if (obj1.type ~= "laser") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			asteroidHit = false
			local function hit()
				for i = #objectTable, 1, -1 do
					if objectTable[i] == obj1 then
						table.remove(objectTable, i)
						display.remove(obj1)
						obj1 = nil
					end
				end
				for i = #asteroidsTable, 1, -1 do
					if (( asteroidsTable[i] == obj2 )and asteroidHit ~= true) then
						asteroidHit = true
						obj2.health = obj2.health - 1
						if (obj2.health <= 0) then
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet,1,102,85)
								newSmallAsteroid:scale(0.4,0.4)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.x, newSmallAsteroid.y = obj2:localToContent(60,60) --+ (math.random(-20,20))
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

		elseif ((obj1.type == "laser" and obj2.type == "smallAsteroid") or 
				(obj1.type == "smallAsteroid" and obj2.type == "laser")) then
			--smallAsteroidHit = false
			local function hit()
				display.remove(obj1)
				display.remove(obj2)
				if (obj1.type ~= "laser") then
					obj3 = obj1
					obj1 = obj2
					obj2 = obj3
					obj3 = nil
				end
				for i = #objectTable, 1, -1 do
					if (objectTable[i] == obj1) then --and (smallAsteroidHit ~= false)) then
						table.remove(objectTable, i)
						obj1 = nil
						smallAsteroidHit = true
						--print("both removed")

						break
					end
				end
			end
			timer.performWithDelay(1,hit)

		
		elseif 	((obj1.name == "asteroid" and obj2.name == "smallAsteroid") or
				(obj1.name == "smallAsteroid" and obj2.name == "asteroid")) then
			if (obj1.name ~= "asteroid") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			--print("collision")
			asteroidHit = false
			local function hit()
				display.remove(obj2)
				--print("hit function")
				for i = #asteroidsTable, 1, -1 do
					--print(i)
					if (( asteroidsTable[i] == obj1) and asteroidHit ~= true) then
						asteroidHit = true
						obj1.health = obj1.health - 1
						--print("asteroid health" .. obj1.health)
						if (obj1.health <= 0) then
							--print ("asteroid dead")
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet,1,102,85)
								newSmallAsteroid:scale(0.4,0.4)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.x, newSmallAsteroid.y = obj1:localToContent(60,60) --+ (math.random(-20,20))
								newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
								newSmallAsteroid:applyTorque(-0.1,0.1)
								newSmallAsteroid.newSpawn = true
								local function spawnIn()
									newSmallAsteroid.newSpawn = false
									--print("Small Asteroid no longer protected")
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

		elseif (obj1.name == "asteroid" and obj2.name == "asteroid") then
			asteroidHit1 = false
			asteroidHit2 = false
			local function hit()
				for i = #asteroidsTable, 1, -1 do
					if (( asteroidsTable[i] == obj1 )and asteroidHit1 ~= true) then
						asteroidHit = true
						obj1.health = obj1.health - 1
						if (obj1.health <= 0) then
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet,1,102,85)
								newSmallAsteroid:scale(0.4,0.4)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.x, newSmallAsteroid.y = obj1:localToContent(60,60) --+ (math.random(-20,20))
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
					if (( asteroidsTable[i] == obj2 )and asteroidHit2 ~= true) then
						asteroidHit2 = true
						obj2.health = obj2.health - 1
						if (obj2.health <= 0) then
							local function spawnSmallAsteroid()
								local newSmallAsteroid = display.newImage(mainGroup,objectSheet,1,102,85)
								newSmallAsteroid:scale(0.4,0.4)
								physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
								newSmallAsteroid.name = "smallAsteroid"
								newSmallAsteroid.type = "smallAsteroid"
								newSmallAsteroid.x, newSmallAsteroid.y = obj2:localToContent(60,60) --+ (math.random(-20,20))
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

		elseif ((obj1.name == "smallAsteroid" and obj1.newSpawn == false) and (obj2.name == "smallAsteroid" and obj2.newSpawn == false)) then
			display.remove(obj1)
			display.remove(obj2)

		elseif (obj1.type == "ship" and obj2.type == "ship" and reset == false) then
			if (obj1.name ~= "ship1") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			print(reset)
			reset = true
			print(reset)
			collision1 = true
			collision2 = true
			print("ship collision")
			obj1.health = obj1.health -1
			print("obj1 health: "..obj1.health)
			if (obj1.health <= 0 and collision1 == true) then
				print("inside collision")
				collision1 = false
				died1 = true
				lives1 = lives1 - 1
				lives1Text.text = "Player 1 Lives: " .. lives1
				if ( lives1 <= 0 ) then
					display.remove( ship1 )
					display.remove( ship2 )
					timer.performWithDelay( 4000, endGame )
				else
					ship1.alpha = 0
					timer.performWithDelay( 1000, restoreShip1 )
				end
			end

			obj2.health = obj2.health -1
			print("obj2 health: "..obj2.health)
			if (obj2.health <= 0 and collision2 == true) then
				collision2 = false
				print("in obj2 death")
				died2 = true
				lives2 = lives2 - 1
				lives2Text.text = "Player 2 Lives: " .. lives2
				if ( lives2 <= 0 ) then
					display.remove( ship1 )
					display.remove( ship2 )
					timer.performWithDelay( 4000, endGame )
				else
					ship2.alpha = 0
					timer.performWithDelay( 1000, restoreShip2 )
				end
			end

			local function preCollision()
				print ("starting reset")
				reset = false
				print("reseting done")
			end
		
			timer.performWithDelay(100,preCollision)
				
			if (lives1 == 0 or lives2 == 0) then
				if (lives1 > lives2) then
					winnerText = display.newText( uiGroup, "PLAYER 1 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
				elseif (lives1 < lives2) then
					winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
				else
					winnerText = display.newText( uiGroup, "DRAW", display.contentWidth/2, 150, native.systemFont, 30 )
				end
			end
		
		elseif((obj1.name == "ship2" and obj2.name == "laser1") or
			(obj1.name == "laser1" and obj2.name == "ship2")) then
			if (obj1.name ~= "ship2") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			shipHit = false
			local function hit()
				for i = #objectTable, 1, -1 do
					if objectTable[i] == obj2 then
						table.remove(objectTable, i)
						display.remove(obj2)
						obj2 = nil
					end
				end
				if(shipHit == false) then
					shipHit = true
					obj1.health = obj1.health - 1
					if (obj1.health <= 0) then
						died2 = true
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
			timer.performWithDelay(1,hit)

		elseif((obj1.name == "ship1" and obj2.name == "laser2") or
			(obj1.name == "laser2" and obj2.name == "ship1")) then
			if (obj1.name ~= "ship1") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			shipHit = false
			local function hit()
				for i = #objectTable, 1, -1 do
					if objectTable[i] == obj2 then
						table.remove(objectTable, i)
						display.remove(obj2)
						obj2 = nil
					end
				end
				if(shipHit == false) then
					shipHit = true
					obj1.health = obj1.health - 1
					if (obj1.health <= 0) then
						died1 = true
						lives1 = lives1 - 1
						lives1Text.text = "Player 1 Lives: " .. lives1

						if ( lives1 == 0 ) then
							display.remove( ship2 )
							winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
							display.remove( ship1 )
							timer.performWithDelay( 4000, endGame )
						else
							ship1.alpha = 0
							timer.performWithDelay( 1000, restoreShip1 )
						end
					end
				end
			end
			timer.performWithDelay(1,hit)

		elseif((obj1.type == "ship" and obj2.name == "smallAsteroid") or 
			(obj1.name == "smallAsteroid" and obj2.type == "ship")) then
			if (obj1.type ~= "ship") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			shipHit = false
			display.remove(obj2)
			local function hit()
				if(shipHit == false) then
					shipHit = true
					if (obj1.name == "ship1") then
						obj1.health = obj1.health - 1
						if (obj1.health <= 0) then
							died1 = true
							lives1 = lives1 - 1
							lives1Text.text = "Player 1 Lives: " .. lives1

							if ( lives1 == 0 ) then
								display.remove( ship2 )
								winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
								display.remove( ship1 )
								timer.performWithDelay( 4000, endGame )
							else
								ship1.alpha = 0
								timer.performWithDelay( 1000, restoreShip1 )
							end
						end
					elseif (obj1.name == "ship2") then
						obj1.health = obj1.health -1
						if(obj1.helth <= 0) then
							died2 = true
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
			timer.performWithDelay(1,hit)
			
			elseif((obj1.type == "ship" and obj2.name == "asteroid") or 
			(obj1.name == "asteroid" and obj2.type == "ship")) then
			if (obj1.type ~= "ship") then
				obj3 = obj1
				obj1 = obj2
				obj2 = obj3
				obj3 = nil
			end
			shipHit = false
			local function hit()
				if(shipHit == false) then
					shipHit = true
					for i = #asteroidsTable, 1, -1 do
					--print(i)
						if (( asteroidsTable[i] == obj2) and shipHit == true) then
							asteroidHit = true
							obj2.health = obj2.health - 1
							--print("asteroid health" .. obj2.health)
							if (obj2.health <= 0) then
								--print ("asteroid dead")
								local function spawnSmallAsteroid()
									local newSmallAsteroid = display.newImage(mainGroup,objectSheet,1,102,85)
									newSmallAsteroid:scale(0.4,0.4)
									physics.addBody(newSmallAsteroid,"dynamic", {radius = 17, bounce = 0.2})
									newSmallAsteroid.name = "smallAsteroid"
									newSmallAsteroid.type = "smallAsteroid"
									newSmallAsteroid.x, newSmallAsteroid.y = obj2:localToContent(60,60) --+ (math.random(-20,20))
									newSmallAsteroid:setLinearVelocity(math.random(-40,40),math.random(-40,40))
									newSmallAsteroid:applyTorque(-0.1,0.1)
									newSmallAsteroid.newSpawn = true
									local function spawnIn()
										newSmallAsteroid.newSpawn = false
										--print("Small Asteroid no longer protected")
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
							died1 = true
							lives1 = lives1 - 1
							lives1Text.text = "Player 1 Lives: " .. lives1

							if ( lives1 == 0 ) then
								display.remove( ship2 )
								winnerText = display.newText( uiGroup, "PLAYER 2 WINS", display.contentWidth/2, 150, native.systemFont, 30 )
								display.remove( ship1 )
								timer.performWithDelay( 4000, endGame )
							else
								ship1.alpha = 0
								timer.performWithDelay( 1000, restoreShip1 )
							end
						end
					elseif (obj1.name == "ship2") then
						obj1.health = obj1.health -1
						if(obj1.health <= 0) then
							died2 = true
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

	makeAsteroidBumpers()
	makeOtherBumpers()
	makeLaserBumpers()

	lives1Text = display.newText(uiGroup, "Player 1 Lives: ".. lives1, 100, 20, native.SystemFont, 20)
	lives2Text = display.newText(uiGroup, "Player 2 Lives: ".. lives2, display.contentWidth - 100, 20, native.SystemFont, 20)

	ship1 = display.newImage(mainGroup, objectSheet, 4, 33, 27)
	ship1:scale(0.5,0.5)
	ship1.x = 100
	ship1.y = display.contentCenterY
	physics.addBody(ship1, "dynamic", {radius = 15, bounce = 0.5})--, isSensor = true})
	ship1.name = "ship1"
	ship1.type = "ship"
	ship1.health = 4
	ship1:rotate(90)

	ship2 = display.newImage(mainGroup, objectSheet2, 4, 33, 27)
	ship2:scale(0.5,0.5)
	ship2.x = display.contentWidth - 100
	ship2.y = display.contentCenterY
	physics.addBody(ship2, "dynamic", {radius = 15,  bounce = 0.5})--, isSensor = true})
	ship2.name = "ship2"
	ship2.type = "ship"
	ship2.health = 4
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


--[[
Have a copy of item spawned (onEnterFrame) that spawns on the other side, with some velocity as properties of original object, then remove additional object 
function clone() to copy that object need to flip x & y
may have to offset
have 


Otherwise have to create an additional bumper just for lasers

Make a spawn of 3 mini asteroids, same size as the ship at x.y
]]