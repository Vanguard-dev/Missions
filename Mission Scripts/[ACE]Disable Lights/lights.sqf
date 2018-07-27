_types = ["Lamps_Base_F", "PowerLines_base_F"];
_onoff = _this select 0;

for [{_i=0},{_i < (count _types)},{_i=_i+1}] do
{
    // powercoverage is a marker I placed.
	_lamps = getMarkerPos "Lights" nearObjects [_types select _i, 2500];
	sleep 1;
	{_x setDamage _onoff} forEach _lamps;
};


// Place down any marker, set it's variable name to "Lights" (if it's a normal marker you can make it invisible.)
// the "2500" is the distance, i wouldn't set it to cover the map thats not really a good idea.