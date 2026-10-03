/*
    File: fn_medical_state_init_unit.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Ensures a unit has an authoritative server medical state and replicated subset.

    Parameter(s):
        _unit - Unit to initialize [OBJECT]

    Returns:
        True when initialized [BOOLEAN]
*/

params [["_unit", objNull, [objNull]]];

if (!isServer || isNull _unit) exitWith {false};

private _state = [_unit] call vn_mf_fnc_medical_state_get;
if (count _state == 0) exitWith {false};

_state set ["lastDamageAt", -1];
_state set ["bleedoutAt", -1];
_state set ["lastReplicatedAt", -1];

_unit setVariable ["vn_mf_medical_server_ready", true, true];
_unit setVariable ["vn_revive_incapacitated", false, true];

[_unit, true] call vn_mf_fnc_medical_replicate_state;
true
