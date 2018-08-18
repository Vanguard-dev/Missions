vcoFirstTask = {
	// Fetch reference to our initial objective entity
	_task00ObjectiveName = "task_00_building00";
	_task00Objective = missionNamespace getVariable [_task00ObjectiveName, objNull];
	if (isNull _task00Objective) exitWith { // Ensure the entity exists
		["Null ref %1", _task00ObjectiveName] call BIS_fnc_error;
	};

	// Create and assign the first task
	[west, "task_00", ["You need to disable the communication jammer as soon as possible to establish tactical uplink with the command.", "Disable Communication Jammer"], _task00Objective, true, 1, false, "destroy", true] call BIS_fnc_taskCreate;
	["task_00", "Assigned"] call BIS_fnc_taskSetState;

	// This function is used to complete the event
	completeFirstTask = {
		["task_00", "Succeeded"] call BIS_fnc_taskSetState;
		// TODO: Create and assign the second task
	};

	// Add manual action to complete the first objective
	_task00Objective addAction ["Disable Communication Jammer", { call completeFirstTask; }, nil, 1, true, true, "", "_this distance _target < 5"];

	// Bind an event to handle the destruction of the objective
	_task00Objective addEventHandler ["Killed", {
		call completeFirstTask;
	}];
};

call vcoFirstTask;