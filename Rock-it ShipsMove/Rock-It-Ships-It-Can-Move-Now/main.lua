-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

function on_key_press(event)
	if event.keyName == "f2" then
		composer.gotoScene("help", {})
	end

	return true
end

Runtime:addEventListener("key", on_key_press)
-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the rng
math.randomseed( os.time() )

-- Go to the menu screen
composer.gotoScene( "menu" )
