/*
	Author: Joona Romppanen

	Description:
	Deletes the given vehicle if it's empty.

	Parameter(s):
		0: STRING or OBJECT - Vehicle name or reference to check against.

	Returns:
	Nothing
*/
_vehicle = param [0, objNull, ["", objNull]];

if (typeName _vehicle == "STRING") then {
	_vehicle = _vehicle call VCO_fnc_getObjectByName;
};

if (count crew _vehicle == 0) then {
	deleteVehicle _vehicle;
};