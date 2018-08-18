waitUntil {time > 0};
enableEnvironment [false, true];

if (isServer) then {
	[] execVM "tasks.sqf";
	[["base_00", "base_01", "base_02"]] execVM "fn_garrisonGroups.sqf";
}