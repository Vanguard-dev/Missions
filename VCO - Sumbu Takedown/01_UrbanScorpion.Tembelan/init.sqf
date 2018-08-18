waitUntil {time > 0};
enableEnvironment [false, true];

if (isServer) then {
	[] execVM "tasks.sqf";
}