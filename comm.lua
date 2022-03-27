local parameters = {
	fighter = true,
	radar = true,
	ECM = true,
	refueling = true --war vorher false
}
return utils.verifyChunk(utils.loadfileIn('Scripts/UI/RadioCommandDialogPanel/Config/LockOnAirplane.lua', getfenv()))(parameters)