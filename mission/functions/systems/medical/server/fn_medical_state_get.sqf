/*
    File: fn_medical_state_get.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Gets or creates authoritative server medical state for a unit.

    Parameter(s):
        _unit - Unit to query [OBJECT]

    Returns:
        Medical state [HASHMAP]
*/

params [["_unit", objNull, [objNull]]];

if (!isServer || isNull _unit) exitWith {createHashMap};

if (isNil "vn_mf_medical_state_registry") then {
    vn_mf_medical_state_registry = createHashMap;
};

private _key = netId _unit;
if (_key isEqualTo "") then {
    _key = str _unit;
};

private _state = vn_mf_medical_state_registry getOrDefault [_key, createHashMap];
if (_state isEqualType createHashMap && {count _state > 0}) exitWith {
    _state
};

_state = call vn_mf_fnc_medical_state_default;
vn_mf_medical_state_registry set [_key, _state];

_state
