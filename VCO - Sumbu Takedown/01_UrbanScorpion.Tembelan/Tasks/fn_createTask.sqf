/*
	Author: Joona Romppanen

	Description:
	Returns a reference a named object or throws an error if the object doesn't exist.

	Parameter(s):
		0: STRING: Name of the task.
		1: STRING: Title of the task.
		2: STRING: Description of the task.
		3: OBJECT or ARRAY: Destination object or coordinates for the task.
		4: BOOLEAN or OBJECT or GROUP or SIDE or ARRAY: Owner of the task.
		5: ARRAY (Optional): Optional task parameters: state, priority, showNotification, type and isShared. See https://community.bistudio.com/wiki/BIS_fnc_taskCreate for details.
		6: CODE (Optional): Code block to be executed on task creation. Will recieve task name and task destination as parameters.
		7: ARRAY (Optional): Array of child tasks for this task. Arguments are the same as this script.

	Returns:
	Nothing
*/
private _name = param [0, "", [""]];
private _title = param [1, "", [""]];
private _description = param [2, "", [""]];
private _destination = param [3, objNull, [objNull, [], ""]];
private _owner = param [4, west, [true, objNull, grpNull, west, []]];
private _optionals = param [5, [], [[]]];
private _taskLogic = param [6, {}, [{}]];
private _childTasks = param [7, [], [[]]];

private _type = _optionals param [0, "attack", [""]];
private _state = _optionals param [1, "Created", [true, 0, ""]];
private _priority = _optionals param [2, 1, [0]];
private _parent = _optionals param [3, "", [""]];
private _showNotification = _optionals param [4, true, [true]];
private _isShared = _optionals param [5, false, [true]];

systemChat format ["[DEBUG] Creating task '%1' with %2 children", _name, count _childTasks];
systemChat format ["[DEBUG] Destination: %1", _destination];
systemChat format ["[DEBUG] Optionals: %1", _optionals];
systemChat "[DEBUG] Executing task logic";
[_name, _destination] call _taskLogic;

if (_parent != "") then {
	[_owner, [_name, _parent], [_description, _title], _destination, _state, _priority, _showNotification, _type, _isShared] call BIS_fnc_taskCreate;
} else {
	[_owner, _name, [_description, _title], _destination, _state, _priority, _showNotification, _type, _isShared] call BIS_fnc_taskCreate;
};

if (count _childTasks > 0) then {
	parentName = _name;
	{
		systemChat format ["[DEBUG] Creating child task '%1' for '%2' with %3 children", _x select 0, parentName, _x select 7];
		private _childOptionals = _x select 5;
		_childOptionals set [3, parentName];
		_x call VCO_fnc_createTask;
	} forEach _childTasks;
	parentName = nil;
};

nil;