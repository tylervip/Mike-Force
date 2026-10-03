/*
    File: fn_medical_send_wound.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Converts a wound tier into a wound increment and sends it to the server.
        Runs on the machine that owns the damaged unit.

    Parameter(s):
        _unit - Damaged unit [OBJECT]
        _selection - Hit selection [STRING]
        _tier - Wound tier, 1 (light) to 3 (severe) [NUMBER]
        _source - Source object [OBJECT]
        _projectile - Projectile class [STRING]
        _hitIndex - Hit index [NUMBER]
        _instigator - Instigator [OBJECT]
        _hitPoint - Hit point [STRING]

    Returns:
        None
*/

params ["_unit", "_selection", "_tier", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

if (!local _unit) exitWith {};

private _increments = missionNamespace getVariable ["vn_mf_medical_wound_increments", [0.2, 0.35, 0.5]];
private _damageReduction = missionNamespace getVariable ["vn_mf_medical_damage_reduction", -1];
if (_damageReduction < 0) then {
    _damageReduction = ["medical_damage_reduction", 25] call BIS_fnc_getParamValue;
    missionNamespace setVariable ["vn_mf_medical_damage_reduction", _damageReduction];
};

private _increment = (_increments select ((_tier - 1) max 0 min 2)) * (1 - ((_damageReduction max 0 min 100) / 100));

[
    _unit, _selection, _increment, _source, _projectile, _hitIndex,
    _instigator, _hitPoint, diag_tickTime, false
] remoteExecCall ["vn_mf_fnc_medical_ingest_damage", 2];
