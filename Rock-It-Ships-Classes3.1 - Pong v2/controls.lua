--
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function returntoMenu()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function gotoShipSelect()
	composer.removeScene( "shipSelect" )
	composer.gotoScene( "shipSelect", { time=800, effect="crossFade" } )
end

local controller = { device="", displayName="" }
 
local function setDevice( device, displayName )
 
    -- Set current controller
    controller["device"] = device
   controller["displayName"] = displayName
 
    -- Remove event listeners
    Runtime:removeEventListener( "axis", onAxisEvent )
    --Runtime:removeEventListener( "key", onKeyEvent )
end
 
local function onKeyEvent( event )

    local message = "Device " ..event.device.descriptor.. " key '" .. event.keyName .. "' was pressed " .. event.phase
	local thisPlayer

	if(event.keyName == "buttonA" and event.phase == "down") then
		gotoShipSelect()
		elseif (event.keyName == "buttonA" and event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
	end
	if(event.keyName == "buttonB" and event.phase == "down") then
		returntoMenu()
		elseif (event.keyName == "buttonB" and event.phase=="up") then
			Runtime:removeEventListener("key", onKeyEvent)
		end
		
	return true
end
Runtime:addEventListener( "key", onKeyEvent )
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

	local background = display.newImageRect( borderGroup, name, 1920, 1080 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local header = display.newImageRect( sceneGroup, "controlsHeader.png", 750, 750)
	header.x = 400
	header.y = 130

	local border = display.newImageRect( sceneGroup, "shipSelectBorder.png", 1920, 1080 )
	border.x = display.contentCenterX
	border.y = display.contentCenterY
	
	local controls = display.newText( sceneGroup, "Left trigger to move\nRight stick to rotate ship\nRight  trigger to fire laser\nStart to start the game", display.contentCenterX, 400, native.systemFont, 75)
	controls:setFillColor(1,1,0)
	
	local playButton = display.newImageRect(sceneGroup, "playButton.png", 1000, 1000 )
	playButton.x = display.contentCenterX
	playButton.y = 800
	
	local returnButton = display.newImageRect(sceneGroup, "returnButton.png", 1000, 1000 )
	returnButton.x = display.contentCenterX
	returnButton.y = 1000

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


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
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