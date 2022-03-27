local oms       	 = require('optionsModsScripts')

local result = {}

result["CPLocalList_VSN_F104G"]				= oms.getCPLocalList("Cockpit_VSN_F104G")
result["CPLocalList_VSN_F104S"]				= oms.getCPLocalList("Cockpit_VSN_F104S")	
result["CPLocalList_VSN_F104S_AG"]			= oms.getCPLocalList("Cockpit_VSN_F104S_AG")		

return result