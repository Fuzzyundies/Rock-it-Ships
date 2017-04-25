
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local	menuMusicsChannel		 = audio.loadSound( "menuMusic.mp3" )
local function gotoGame()
	composer.removeScene( "game" )
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoMenu()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function gotoPong()
	composer.removeScene( "pong" )
	composer.gotoScene( "pong", { time=800, effect="crossFade" } )
end

local function gotoHazards()
	composer.removeScene( "hazards" )
	composer.gotoScene( "hazards", { time=800, effect="crossFade" } )
end

local function onKeyEvent( event )
   
    local message = "Device " ..event.device.descriptor.. " key '" .. event.keyName .. "' was pressed " .. event.phase
	local thisPlayer

	if(event.keyName == "buttonA")then
		if (event.phase=="down") then
			gotoGame()
		elseif (event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
		end
	end

	if (event.keyName=="buttonY") then
		if (event.phase=="down") then
			gotoHazards()
		elseif (event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
		end
	end

	if (event.keyName=="buttonX") then
		if (event.phase=="down") then
			gotoPong()
		elseif (event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
		end
	end

	if (event.keyName=="buttonB") then
		if (event.phase=="down") then
			gotoMenu()
		elseif (event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)	
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	local borderGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local menuMusicsChannel1 = audio.play( menuMusicsChannel, { channel=2, loops=-1, fadein=5000 } )
	audio.setVolume( 0.75, { channel=2 } )

	local backNum = math.random( 4 )
	local name = "nebula".. backNum..".png"

	local background = display.newImageRect( borderGroup, name, 1920, 1080 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local border = display.newImageRect( sceneGroup, "shipSelectBorder.png", 1920, 1080 )
	border.x = display.contentCenterX
	border.y = display.contentCenterY

	local header = display.newImageRect( sceneGroup, "modeSelection.png", 750, 750)
	header.x = 400
	header.y = 130

	local originalButton = display.newImageRect(sceneGroup, "original.png", 600, 600 )
	originalButton.x = display.contentCenterX - 50
	originalButton.y = 1000

	local originalBadge = display.newImageRect(sceneGroup, "ship1P1.png", 600, 600 )
	originalBadge.x = display.contentCenterX
	originalBadge.y = 600

	local pongButton = display.newImageRect(sceneGroup, "pongMode.png", 600, 600 )
	pongButton.x = display.contentCenterX - 650
	pongButton.y = 450

	local pongBadge = display.newImageRect(sceneGroup, "pongsteroid.png", 400, 400 )
	pongBadge.x = display.contentCenterX - 600
	pongBadge.y = 700

	local hazardsButton = display.newImageRect(sceneGroup, "hazards.png", 600, 600 )
	hazardsButton.x = display.contentCenterX + 480
	hazardsButton.y = 450

	local hazardsBadge = display.newImageRect(sceneGroup, "blackHoleFull.png", 400, 400 )
	hazardsBadge.x = display.contentCenterX + 530
	hazardsBadge.y = 700


end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

		Runtime:addEventListener( "key", onKeyEvent )

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local borderGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

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
