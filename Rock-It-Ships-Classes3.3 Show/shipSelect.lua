
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local	selectChannel		  	 = audio.loadSound( "Select3cc.wav" )


local function gotoModeSelect()
	composer.removeScene( "modeSelect" )
	composer.gotoScene( "modeSelect", { time=800, effect="crossFade" } )
end

local function gotoMenu()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=800, effect="crossFade" })
end

local playerOne
local playerTwo
_G.player1Ship = ""
_G.player2Ship = ""
_G.thruster1 = 0
_G.thruster2 = 0
local ready = 0
local ready1 = false
local ready2 = false




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	local borderGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local backNum = math.random( 4 )
	local name = "nebula".. backNum..".png"

	local background = display.newImageRect( sceneGroup, name, 1920, 1080 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local border = display.newImageRect( borderGroup, "shipSelectBorder.png", 1920, 1080 )
	border.x = display.contentCenterX
	border.y = display.contentCenterY

	local header = display.newImageRect( sceneGroup, "shipSelection.png", 750, 750)
	header.x = 400
	header.y = 130

	local shipSelect1 = display.newImageRect( sceneGroup, "ship1P1.png", 500, 500)
	shipSelect1.x = display.contentCenterX
	shipSelect1.y = 400

	 aButton = display.newImageRect( sceneGroup, "aButton.png", 100, 100)
	aButton.x = display.contentCenterX
	aButton.y = 700

	local shipSelect2 = display.newImageRect( sceneGroup, "ship2P1.png", 500, 500)
	shipSelect2.x = display.contentCenterX - 550
	shipSelect2.y = 600

	 yButton = display.newImageRect( sceneGroup, "yButton.png", 100, 100)
	yButton.x = display.contentCenterX - 550
	yButton.y = 900

	local shipSelect3 = display.newImageRect( sceneGroup, "ship3P1.png", 500, 500)
	shipSelect3.x = display.contentCenterX + 550
	shipSelect3.y = 600
	
	local returnButton = display.newImageRect(sceneGroup, "returnButton.png", 500, 500 )
	returnButton.x = display.contentCenterX
	returnButton.y = 1000


	 xButton = display.newImageRect( sceneGroup, "xButton.png", 100, 100)
	xButton.x = display.contentCenterX + 550
	xButton.y = 900

	 player1SS = display.newImageRect(sceneGroup, "p1.png", 300, 300)
	 player2SS = display.newImageRect(sceneGroup, "p2.png", 300, 300)
	player1SS.alpha=0
	player2SS.alpha=0
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end	
	
local function onKeyEvent(event)
	local message = "Device " ..event.device.descriptor.. " key '" .. event.keyName .. "' was pressed " .. event.phase
	local thisPlayer
 
    if ( event.device.descriptor == "Gamepad 1" ) then
        thisPlayer = player1
        if (event.keyName == "buttonA" and event.phase == "down" ) then
        	player1Ship = "ship1P1.png" 
			player1SS.alpha=0
			player1SS.x= aButton.x-100
			player1SS.y= aButton.y
			player1SS.alpha=1
        	thruster1 =1
        	ready1 = true
        	--[[delete
        	player2Ship = "ship1P2.png"
			player2SS.x= aButton.x+100
			player2SS.y= aButton.y
			player2SS.alpha=1			
        	thruster2 =1
        	ready2 = true
        	]]--print "a"
        elseif (event.keyName == "buttonY" and event.phase == "down" ) then
        	player1Ship = "ship2P1.png"
			player1SS.x= yButton.x-100
			player1SS.y= yButton.y
			player1SS.alpha=1
        	thruster1 =2
        	ready1 = true
        	--[[delete
        	player2Ship = "ship2P2.png" 
			player2SS.x= yButton.x+100
			player2SS.y= yButton.y
			player2SS.alpha=1
        	thruster2 =2
        	ready2 = true
        	]]--print "y"
        elseif (event.keyName == "buttonX" and event.phase == "down" ) then 
        	player1Ship = "ship3P1.png" 
			player1SS.x= xButton.x-100
			player1SS.y= xButton.y
			player1SS.alpha=1
        	thruster1 =3
        	ready1 = true
        	--[[delete
        	player2Ship = "ship3P2.png" 
			player2SS.x= xButton.x+100
			player2SS.y= xButton.y
			player2SS.alpha=1
        	thruster2 =3
        	ready2 = true
        	]]--print "x"
        end

    else
        thisPlayer = player2
         if (event.keyName == "buttonA" and event.phase == "down" ) then
        	local menuMusicsChannel12 = audio.play( selectChannel, { channel=3} )
        	player2Ship = "ship1P2.png"
			player2SS.x= aButton.x+100
			player2SS.y= aButton.y
			player2SS.alpha=1			
        	thruster2 =1
        	ready2 = true
        	--print "a"
        elseif (event.keyName == "buttonY" and event.phase == "down" ) then
        	local menuMusicsChannel12 = audio.play( selectChannel, { channel=3} )
        	player2Ship = "ship2P2.png" 
			player2SS.x= yButton.x+100
			player2SS.y= yButton.y
			player2SS.alpha=1
        	thruster2 =2
        	ready2 = true
        	--print "y"
        elseif (event.keyName == "buttonX" and event.phase == "down" ) then 
        	local menuMusicsChannel12 = audio.play( selectChannel, { channel=3} )
        	player2Ship = "ship3P2.png" 
			player2SS.x= xButton.x+100
			player2SS.y= xButton.y
			player2SS.alpha=1
        	thruster2 =3
        	ready2 = true
        	--print "x"
        end
		print (player1Ship)
        print (player2Ship)
    end

    if(event.keyName == "buttonB" and event.phase == "down") then
    	local menuMusicsChannel12 = audio.play( selectChannel, { channel=3} )
		gotoMenu()
		elseif (event.keyName == "buttonB" and event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
	end
    
    if(event.keyName == "buttonStart" and event.phase == "down") then
		if (ready1 == true and ready2 == true ) then
    	gotoModeSelect()
		end
    elseif (event.keyName == "buttonStart" and event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
	end

   return true
   --print("ready1: "..tostring(ready1).." ready2: "..tostring(ready2))
end
Runtime:addEventListener( "key", onKeyEvent )



-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local borderGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		ready = 0

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
