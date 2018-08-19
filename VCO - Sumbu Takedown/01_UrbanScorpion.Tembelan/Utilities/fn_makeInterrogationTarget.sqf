// Makes a unit a critical interrogation target.
// This will make the unit collapse when shot and invulnerable until the interrogation has been done.
//
// Usage: ["myUnit", { call revealNextTask; }] call VCO_fnc_makeInterrogationTarget;
// Parameters:
// 0 - Target unit. Can be the name of the unit or a direct reference.
// 1 - Callback function or a script file to be called after the interrogation has been triggered.
_unit = param [0, objNull, [objNull, ""]];
callback = param [1, {}, [{}]];

if (typeName _unit == "STRING") then {
	_unit = _unit call VCO_fnc_getObjectByName;
};

_unit allowDamage false;
damageHandler =  _unit addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

	_unit removeEventHandler ["HandleDamage", damageHandler];
	
	_target allowDamage true;
	_target setDamage 0.96;
	_target setHit ["body", 0.96, false];
	_target setHit ["legs", 0.96, false];
	_target setHit ["hands", 0.96, false];
	_target allowDamage false;
	_unit setCaptive true;
	_unit switchmove "Acts_InjuredLyingRifle01";
	interrogationAction = _unit addAction ["Interrogate", {
		params ["_target", "_caller", "_actionId", "_arguments"];
		
		_target removeAction interrogationAction;

		private _callbackHandle = spawn callback;
		waitUntil {scriptDone _callbackHandle};

		_target allowDamage true;
		executeAction = _target addAction ["Execute", {
			params ["_target", "_caller", "_actionId", "_arguments"];
		
			_target removeAction executeAction;
			_target setDamage 1;
		}, nil, 1, false, true];
	}, nil, 1, true, true, "", "_this distance _target < 3"];
}];