/*
    File: fn_medical_bleedout_job.sqf
    Author: Tylervip
    Public: No

    Description:
        Kills server-tracked players whose custom medical bleedout timer has expired.

    Parameter(s): none

    Returns:
        None
*/

if (!isServer) exitWith {};

{
    private _unit = _x;
    if (!alive _unit) then {continue};

    private _state = [_unit] call vn_mf_fnc_medical_state_get;
    if (count _state == 0) then {continue};

    private _bleedoutAt = _state getOrDefault ["bleedoutAt", -1];
    if (
        (_state getOrDefault ["unconscious", false])
        && {_bleedoutAt > 0}
        && {serverTime >= _bleedoutAt}
    ) then {
        _state set ["bleedoutAt", -1];
        [_unit, 1] remoteExecCall ["setDamage", _unit];
    };
} forEach allPlayers;
