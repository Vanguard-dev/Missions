/*
	Author: Joona Romppanen

	Description:
	Returns a reference a named object or throws an error if the object doesn't exist.

	Parameter(s):
		0 (Optional): STRING - Name of the wanted object.

	Returns:
	OBJECT
*/
_objectName = param [0, objNull, [""]];

_object = missionNamespace getVariable [_objectName, objNull];
if (isNull _object) exitWith {
	["Unable to object with the name of %1", _objectName] call BIS_fnc_error;
};

_object;