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

{
    if (isPlayer _x) then {
        [_x] call vn_mf_fnc_medical_state_init_unit;
    };
} forEach allPlayers;
