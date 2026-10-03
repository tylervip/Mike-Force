/*
    File: fn_medical_server_init.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Initializes the server-side medical registry and seeds current players.

    Parameter(s): none

    Returns:
        None
*/

if (!isServer) exitWith {};

if (isNil "vn_mf_medical_state_registry") then {
    vn_mf_medical_state_registry = createHashMap;
};

private _damageReduction = ["medical_damage_reduction", 25] call BIS_fnc_getParamValue;
private _bleedoutTime = ["bleedout_time", 120] call BIS_fnc_getParamValue;
missionNamespace setVariable ["vn_mf_medical_damage_reduction", _damageReduction, true];
missionNamespace setVariable ["vn_mf_medical_bleedout_time", _bleedoutTime, true];

["medical_bleedout", vn_mf_fnc_medical_bleedout_job, [], 1] call para_g_fnc_scheduler_add_job;

{
    if (isPlayer _x) then {
        [_x] call vn_mf_fnc_medical_state_init_unit;
    };
} forEach allPlayers;
