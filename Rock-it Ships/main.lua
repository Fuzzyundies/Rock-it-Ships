-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the rng
math.randomseed( os.time() )

-- Go to the menu screen
composer.gotoScene( "menu" )
