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

createInitialTasks = {
	[
		"task_jammers",
		"Disable Communication Jamming capabilities",
		"The militants have acquired high quality Communication Jammers from their funding partners. It is our primary task to disable these jammers so we can establish tactical command for the reclamation operations.",
		objNull, west, ["radio"], {
			systemChat "[DEBUG] Init jammer tasks";
			// Prepare backup jammer logic incase of rogue players
			task02Name = "task_jammers_02";
			task02Target = "task_02_jammer" call VCO_fnc_getObjectByName;
			task02Status = "Assigned";
			task02EventHandle = 0;

			// Bind an event to handle the destruction of the objective
			destroyEvent = task02Target addEventHandler ["Killed", {
				task02Status = "Succeeded";
				[task02Name, task02Status] call BIS_fnc_taskSetState;
				["task_jammers", "Succeeded"] call BIS_fnc_taskSetState; // TODO: Move to watcher
				task02Target removeEventHandler ["Killed", task02EventHandle];
			}];
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
						call createInterrogationTask;
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
	
	[
		"task_airfield",
		"Secure the airfield",
		"We need to secure the airfield to ensure the rapid deployment force won't be annihilated on approach.",
		objNull, west, ["plane"], {
			// Prepare task03 conditions
			task03Name = "task_airfield_01";
			task03Target = "task_03_hvt" call VCO_fnc_getObjectByName;
			task03State = "Created";

			[task03Target, {
				task03State = "Succeeded";
				[task03Name, task03State] call BIS_fnc_taskSetState;
				// TODO: Audio and move to directSay?
				task03Target globalChat "W.. We have a bomb on the airfield.";
				sleep 5;
				task03Target globalChat "All I have to do is wave my hand to the control tower and it goes boom.";
				sleep 5;
				task03Target globalChat "Now please raise me up a bit so I can wave my hand.";
				sleep 10;
				task03Target globalChat "Please?";
				sleep 2;
				// TODO: Add defuse logic to task04 controls
				call createCounterSabotageTask;
			}] call VCO_fnc_makeInterrogationTarget;

			// Prepare task04 conditions
			task04Name = "task_airfield_02";
			task04Target = "task_04_controls" call VCO_fnc_getObjectByName;
			task04EventHandle = 0;

			// Bind an event to handle the destruction of the objective
			task04EventHandle = task04Target addEventHandler ["Killed", {
				[task04Name, "Failed"] call BIS_fnc_taskSetState;
				task04Target removeEventHandler ["Killed", task04EventHandle];
				for "_i" from 1 to 20 do {
					createVehicle ["Bo_GBU12_LGB",[(getMarkerPos "airfield_sabotage_charge" select 0) + (_i * cos (_i * 17.5)), (getMarkerPos "airfield_sabotage_charge" select 1) + (_i * sin (_i * 17.5)), 0], [], 0, "CAN_COLLIDE"];
				};
				"failure1" call BIS_fnc_endMissionServer;
			}];
		}
	] call VCO_fnc_createTask;
};

createSecondJammerTask = {
	[
		"task_jammers_02",
		"Destroy the backup Communication Jammer",
		"To prevent the militants from jamming the communication frequencies again the backup jammer needs to be destroyed. It was last located at a warehouse in the given coordinates.",
		("task_02_jammer" call VCO_fnc_getObjectByName),
		west, ["destroy", task02Status, nil, "task_jammers"]
	] call VCO_fnc_createTask;
};

createInterrogationTask = {
	[
		"task_airfield_01",
		"Interrogate the Sambu leader",
		"Interrogate the Sambu leader for the details on the airfield fortifications.",
		("task_03_hvt" call VCO_fnc_getObjectByName),
		west, ["talk", task03State, nil, "task_airfield"]
	] call VCO_fnc_createTask;
};

createCounterSabotageTask = {
	[
		"task_airfield_02",
		"Disable the sabotage detonation controls",
		"Through the interrogation we discovered that the militia planted a sabotage device in the middle of the runway to prevent the use of it. Head there and disable its controls without allowing anyone to detonate it. DO NOT DESTROY IT. Destroying it will most likely trigger the detonation.",
		("task_04_controls" call VCO_fnc_getObjectByName),
		west, ["mine", nil, nil, "task_airfield"]
	] call VCO_fnc_createTask;
};

call createInitialTasks;