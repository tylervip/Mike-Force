/*
    File: fn_medical_state_reset_unit.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Resets a unit medical state, typically on respawn.

    Parameter(s):
        _unit - Unit to reset [OBJECT]

    Returns:
        True when reset [BOOLEAN]
*/

params [["_unit", objNull, [objNull]]];

if (!isServer || isNull _unit) exitWith {false};

if (isNil "vn_mf_medical_state_registry") then {
    vn_mf_medical_state_registry = createHashMap;
};

private _key = netId _unit;
if (_key isEqualTo "") then {
    _key = str _unit;
};

private _state = call vn_mf_fnc_medical_state_default;
vn_mf_medical_state_registry set [_key, _state];

[_unit, false] remoteExecCall ["vn_mf_fnc_medical_set_unconscious", _unit];
_unit setVariable ["vn_revive_incapacitated", false, true];

[_unit, true] call vn_mf_fnc_medical_replicate_state;
true
