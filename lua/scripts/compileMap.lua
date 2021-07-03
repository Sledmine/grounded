------------------------------------------------------------------------------
-- Grounded Project Compiler
-- Sledmine
-- Script utility to compile the entire Grounded project
------------------------------------------------------------------------------
local argparse = require "lua.scripts.modules.argparse"

local scenarioPath = [[radon\levels\grounded\grounded.scenario]]

-- Create argument parser
local parser = argparse("compileMap", "Compile map project with different configurations")

-- Get script args
local args = parser:parse()

print("Fixing script nodes for stock compatibility...")
local fixScenarioNodes = [[invader-bludgeon -t tags\ -T excessive-script-nodes "%s"]]
os.execute(fixScenarioNodes:format(scenarioPath))
-- Compile map
local compileMapCmd =
    [[cd tags\ & invader-build.exe -t . -P -m "D:\Program Files (x86)\Microsoft Games\Halo Custom Edition\maps" -A pc-custom -E -g pc-custom -q "%s"]]

print("Compiling project...")
local result = os.execute(compileMapCmd:format(scenarioPath))
if (result) then
    print("Project compiled succesfully!")
else
    os.exit(1)
    print("Error, an error occurred while compiling map.")
end
