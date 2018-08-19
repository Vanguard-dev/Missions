/*
	Author: Mission Maker

	Description:
	This function will initialize the tasks for the mission.

	Parameter(s):
		None

	Returns:
	Nothing
*/
params ["_initType", "_didJIP"];

if (!isServer) exitWith {};

systemChat "[DEBUG] Initalizing tasks";

createInitialTask = {
	[
		"task_jammers",
		"Disable Communication Jamming capabilities",
		"The militants have acquired high quality Communication Jammers from their funding partners. It is our primary task to disable these jammers so we can establish tactical command for the reclamation operations.",
		objNull, west, ["radio"], {
			systemChat "[DEBUG] Init jammer tasks";
			// TODO: Jammer parent task logic
		}, [
			[
				"task_jammers_01",
				"Disable the active Communication Jammer",
				"You need to disable the active Communication Jammer as soon as possible to establish tactical uplink with the command.",
				("task_01_jammer" call VCO_fnc_getObjectByName),
				west, ["destroy", true], {
					task01Name = param [0];
					task01Target = param [1];
					task01ActionHandle = 0;
					task01EventHandle = 0;

					// This function is used to complete the event
					completeTask = {
						[task01Name, "Succeeded"] call BIS_fnc_taskSetState;
						call vcoSecondTask;
						call vcoThirdTask;
						task01Target removeAction task01ActionHandle;
						task01Target removeEventHandler ["Killed", task01EventHandle];

						call createSecondJammerTask;
					};

					// Add manual action to complete the first objective
					disableAction = task01Target addAction ["Disable Communication Jammer", { call completeTask; }, nil, 1, true, true, "", "_this distance _target < 5"];

					// Bind an event to handle the destruction of the objective
					disableEvent = task01Target addEventHandler ["Killed", {
						call completeTask;
					}];
				}
			]
		]
	] call VCO_fnc_createTask;
};

createSecondJammerTask = {
	[
		"task_jammers_02",
		"Destroy the backup Communication Jammer",
		"To prevent the militants from jamming the communication frequencies again the backup jammer needs to be destroyed. It was last located at a warehouse in the given coordinates.",
		("task_02_jammer" call VCO_fnc_getObjectByName),
		west, ["destroy", true, nil, "task_jammers"], {
			task02Name = param [0];
			task02Target = param [1];
			task02EventHandle = 0;

			// Bind an event to handle the destruction of the objective
			destroyEvent = task02Target addEventHandler ["Killed", {
				[task02Name, "Succeeded"] call BIS_fnc_taskSetState;
				["task_jammers", "Succeeded"] call BIS_fnc_taskSetState;
				task02Target removeEventHandler ["Killed", task02EventHandle];
			}];
		}
	] call VCO_fnc_createTask;
};

call createInitialTask;