--
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.removeScene( "game" )
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function closeGame()
	native.requestExit()
end

local function gotoControls()
	composer.removeScene( "controls" )
	composer.gotoScene( "controls", { time=800, effect="crossFade" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "background.png", 1920, 1080 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title = display.newImage( sceneGroup, "title.png", display.contentCenterX, 300)

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, native.systemFont, 50)
	playButton:setFillColor( 0.82, 0.86, 1 )
	
	local controlsButton = display.newText( sceneGroup, "Controls", display.contentCenterX, 800, native.systemFont, 50)
	controlsButton:setFillColor( 0.82, 0.86, 1 )
	
	local exitButton = display.newText( sceneGroup, "Exit", display.contentCenterX, 900, native.systemFont, 50)
	exitButton:setFillColor( 0.82, 0.86, 1 )

	playButton:addEventListener( "tap", gotoGame )
	controlsButton:addEventListener("tap",gotoControls)
	exitButton:addEventListener( "tap", closeGame )
	
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
