private _markers = param [0, []];
private _onlyInside = param [1, true];
private _evenFill = param [2, true];

occupy = compileFinal preprocessFileLineNumbers "Zen_OccupyHouse.sqf";
{
	_markerPos = getMarkerPos _x;
	_garrisonRadius = (getMarkerSize _x) select 0; // Take garrison radius based upon marker width
	_nearbyUnits = _markerPos nearEntities ["Man", _garrisonRadius];
	_garrisonUnits = [];
	{
		if ((_x getVariable ["shouldGarrison", true])) then {
			_garrisonUnits = _garrisonUnits + [_x];
		}

		if ((_x getVariable ["shouldGarrisonGroup", true])) then {
			_garrisonUnits = _garrisonUnits + (units group _x);
		}
	} forEach _nearbyUnits;
	[_markerPos, _garrisonUnits, _garrisonRadius, _onlyInside, _evenFill] call occupy;
} forEach _markers;