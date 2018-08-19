/*
	Author: Joona Romppanen

	Description:
	Sets the speed of the target vehicle while taking account it's rotation.

	Parameter(s):
		0: STRING or OBJECT - Name of the vehicle or a reference to the vehicle.
		1 (Optional): NUMBER - Speed for the vehicle.

	Returns:
	Nothing
*/
_vehicle = param [0, objNull, ["", objNull]];
_speed = param [1, 0, [0]];

if (typeName _vehicle == "STRING") then {
	_vehicle = _vehicle call VCO_fnc_getObjectByName;
};

_vehicle engineOn true;
_velocity = velocity _vehicle;
_direction = direction _vehicle;
_speed = 100;
_vehicle setVelocity [
  (_velocity select 0) + (sin _direction * _speed),
  (_velocity select 1) + (cos _direction * _speed),
  (_velocity select 2)
];