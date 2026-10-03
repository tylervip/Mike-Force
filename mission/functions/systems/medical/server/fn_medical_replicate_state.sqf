/*
    File: fn_medical_replicate_state.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Replicates compact state variables used by clients/HUD.

    Parameter(s):
        _unit - Unit to replicate state for [OBJECT]
        _force - Ignore replicate rate cap [BOOLEAN]

    Returns:
        Whether replication was sent [BOOLEAN]
*/

params [
    ["_unit", objNull, [objNull]],
    ["_force", false, [false]]
];

if (!isServer || isNull _unit) exitWith {false};

private _state = [_unit] call vn_mf_fnc_medical_state_get;
if (count _state == 0) exitWith {false};

private _now = serverTime;
private _lastReplicatedAt = _state getOrDefault ["lastReplicatedAt", -1];
if (!_force && {_lastReplicatedAt >= 0} && {(_now - _lastReplicatedAt) < 0.15}) exitWith {false};

private _wounds = _state get "wounds";
private _woundsCompact = [
    _wounds getOrDefault ["head", 0],
    _wounds getOrDefault ["torso", 0],
    _wounds getOrDefault ["arm_l", (_wounds getOrDefault ["arms", 0])],
    _wounds getOrDefault ["arm_r", (_wounds getOrDefault ["arms", 0])],
    _wounds getOrDefault ["leg_l", (_wounds getOrDefault ["legs", 0])],
    _wounds getOrDefault ["leg_r", (_wounds getOrDefault ["legs", 0])]
];

_unit setVariable ["vn_mf_medical_wounds", _woundsCompact, true];
_unit setVariable ["vn_mf_medical_unconscious", _state getOrDefault ["unconscious", false], true];
_unit setVariable ["vn_mf_medical_bleedingRate", _state getOrDefault ["bleedingRate", 0], true];

_state set ["lastReplicatedAt", _now];

true
