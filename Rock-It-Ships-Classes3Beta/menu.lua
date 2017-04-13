--
local composer = require( "composer" )

local scene = composer.newScene()

	local menuMusicsChannel1 = audio.play( menuMusicsChannel, { channel=2, loops=-1, fadein=5000 } )
	audio.setVolume( 0.75, { channel=2 } )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local	menuMusicsChannel		 = audio.loadSound( "menuMusic.mp3" )
local function gotoShipSelect()
	composer.removeScene( "shipSelect" )
	composer.gotoScene( "shipSelect", { time=800, effect="crossFade" } )
end

local function closeGame()
	native.requestExit()
end

local function gotoControls()
	composer.removeScene( "controls" )
	composer.gotoScene( "controls", { time=800, effect="crossFade" } )
end

local controller = { device="", displayName="" }
 
local function setDevice( device, displayName )
 
    -- Set current controller
    controller["device"] = device
    controller["displayName"] = displayName
 
    -- Remove event listeners
    Runtime:removeEventListener( "axis", onAxisEvent )
    Runtime:removeEventListener( "key", onKeyEvent )
end
 
local function onKeyEvent( event )
    setDevice( event.device, event.device.displayName )

    local message = "Device " ..event.device.descriptor.. " key '" .. event.keyName .. "' was pressed " .. event.phase
	local thisPlayer

	if(event.keyName == "buttonA")then
	if (event.phase=="down") then
		gotoShipSelect()
		elseif (event.phase=="up") then
		Runtime:removeEventListener("key", onKeyEvent)
		end
	end

	if (event.keyName=="buttonY") then
		if (event.phase=="down") then
			gotoControls()
		elseif (event.phase=="up") then
		Runtime:removeEventListener("key", onKeyEvent)
		end
	end

	if (event.keyName=="buttonB") then
		if (event.phase=="down") then
		closeGame()
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

	local playButton = display.newImageRect(sceneGroup, "playButton.png", 900, 900 )
	playButton.x = display.contentCenterX
	playButton.y = 700

	local contolsButton = display.newImageRect(sceneGroup, "controls.png", 900, 900 )
	contolsButton.x = display.contentCenterX
	contolsButton.y = 850

	local closeGameButton = display.newImageRect(sceneGroup, "closeGame.png", 900, 900 )
	closeGameButton.x = display.contentCenterX
	closeGameButton.y = 1000

	local title = display.newImageRect(sceneGroup, "gameLogo.png", 1794, 600 )
	title.x = display.contentCenterX
	title.y = 300
	
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
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "key", onKeyEvent )

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
