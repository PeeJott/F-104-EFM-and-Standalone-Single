dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avSimplestRadio')

local dev = GetSelf()

function post_initialize()
    avSimplestRadio.SetupRadios(devices.ELECTRIC_SYSTEM_BATTERY_BUS, devices.INTERCOM_AIC_18, 2, devices.RADIO_ARC_522, devices.RADIO_TR_3)
end

--dev:listen_command(179)
dev:listen_command(Keys.COM1)
dev:listen_command(Keys.COM2)

function SetCommand(command,value)
    if command==Keys.COM1 and value == 1 then
        avSimplestRadio.PTT(1)
    elseif command==Keys.COM2 and value == 1 then
        avSimplestRadio.PTT(2)
    end
end

need_to_be_closed = false


--[[
Two avSimpleElectricSystems are needed to power the radios. All other devices are 
powered with the param_handles for the bus they are connected to.

Both are setup very similar:

AC_Generator_1 is linked to engine 1 and represents the generators behind the AUTOMATIC BUS TRANSFER.
AC_Generator_2 is linked to engine 2 and represtens the EMERGENCY GENERATOR (RAT), so usually it's not running.

AN/ARC-552 UHF is powered by EMERGENCY AC BUS and NO. 1 EMERGENCY DC BUS.
EMERGENCY UHF is powered by the NO. 1 BATTERY BUS, normally energized by the EMERGENCY AC BUS 
or if that fails by the BATTERY.

The default behavior of the avSimpleElectricSystem is that both radios would
run on the battery when both engines are off, which is fine for the EMERGENCY UHF.
For the AN/ARC-552 UHF a second avSimpleElectricSystem is used where the battery is turned off
when the EMERGENCY GENERATOR (RAT) is not running or when the flaps are operated.
--]]
