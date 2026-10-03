/*
    File: fn_medical_ingest_damage.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Server-side ingest of HandleDamage snapshots from the owning client.

    Parameter(s):
        _unit - Damaged unit [OBJECT]
        _selection - Hit selection [STRING]
        _damage - Wound increment added to the body part [NUMBER]
        _source - Source object [OBJECT]
        _projectile - Projectile class [STRING]
        _hitIndex - Hit index [NUMBER]
        _instigator - Instigator [OBJECT]
        _hitPoint - Hit point [STRING]
        _timestamp - Client timestamp [NUMBER]
        _forceUnconscious - Whether this hit would otherwise be lethal [BOOLEAN]

    Returns:
        None
*/

params [
    ["_unit", objNull, [objNull]],
    ["_selection", "", [""]],
    ["_damage", 0, [0]],
    ["_source", objNull, [objNull]],
    ["_projectile", "", [""]],
    ["_hitIndex", 0, [0]],
    ["_instigator", objNull, [objNull]],
    ["_hitPoint", "", [""]],
    ["_timestamp", 0, [0]],
    ["_forceUnconscious", false, [false]]
];

if (!isServer || isNull _unit || {!alive _unit}) exitWith {};

private _owner = owner _unit;
if (_owner <= 0 || {_owner != remoteExecutedOwner}) exitWith {};

if (toLower _hitPoint isEqualTo "incapacitated" && {!isNull _instigator} && {_unit != _instigator}) then {
    private _sideCheck = side _unit == side _instigator;
    private _instigatorIsCurator = [_instigator] call para_g_fnc_db_check_curator;
    private _message = format ["[MACV] %1 has friendly fired %2.", name _instigator, name _unit];

    if (!_instigatorIsCurator && _sideCheck) then {
        {
            private _inMACV = [_x, "MACV"] call para_g_fnc_db_check_whitelist;
            if (!_inMACV) then { continue };
            systemChat _message;
            [_message] remoteExec ["systemChat", _x];
        } forEach allPlayers;

        diag_log format ["[!] Friendly fire name:%1 (UID:%2) incapacitated %3 (UID:%4) with %5", name _instigator, getPlayerUID _instigator, name _unit, getPlayerUID _unit, _projectile];
        ["FriendlyFire", ["Check your fire! You've incapacitated a fellow soldier."]] remoteExec ["para_c_fnc_show_notification", _instigator];
    };
};

if (toLower _hitPoint in ["", "#structural", "incapacitated"]) exitWith {};

private _state = [_unit] call vn_mf_fnc_medical_state_get;
if (count _state == 0) exitWith {};

private _part = [_hitPoint] call vn_mf_fnc_medical_map_hitpoint_to_bodypart;
private _wounds = _state get "wounds";
private _legacyKey = "";
if (_part in ["arm_l", "arm_r"]) then {
    _legacyKey = "arms";
};
if (_part in ["leg_l", "leg_r"]) then {
    _legacyKey = "legs";
};

private _current = _wounds getOrDefault [_part, if (_legacyKey isEqualTo "") then {0} else {_wounds getOrDefault [_legacyKey, 0]}];
private _next = (_current + (_damage max 0)) min 1;
_wounds set [_part, _next];

private _head = _wounds getOrDefault ["head", 0];
private _torso = _wounds getOrDefault ["torso", 0];
private _armL = _wounds getOrDefault ["arm_l", (_wounds getOrDefault ["arms", 0])];
private _armR = _wounds getOrDefault ["arm_r", (_wounds getOrDefault ["arms", 0])];
private _legL = _wounds getOrDefault ["leg_l", (_wounds getOrDefault ["legs", 0])];
private _legR = _wounds getOrDefault ["leg_r", (_wounds getOrDefault ["legs", 0])];
private _arms = (_armL + _armR) * 0.5;
private _legs = (_legL + _legR) * 0.5;

private _bleed = ((_head * 0.45) + (_torso * 0.35) + (_arms * 0.1) + (_legs * 0.1)) min 1;
private _pain = ((_head * 0.35) + (_torso * 0.35) + (_arms * 0.15) + (_legs * 0.15)) min 1;
private _wasUnconscious = _state getOrDefault ["unconscious", false];
private _unconscious = _wasUnconscious || _forceUnconscious || (_head >= 0.95) || (_torso >= 0.95) || (_bleed >= 0.8);

_state set ["bleedingRate", _bleed];
_state set ["pain", _pain];
_state set ["unconscious", _unconscious];
_state set ["lastDamageAt", serverTime];
if (_unconscious && {!_wasUnconscious}) then {
    private _bleedoutTime = missionNamespace getVariable ["vn_mf_medical_bleedout_time", 120];
    _state set ["bleedoutAt", serverTime + _bleedoutTime];
} else {
    if (!_unconscious) then {
        _state set ["bleedoutAt", -1];
    };
};

_unit setVariable ["vn_revive_incapacitated", _unconscious, true];
[_unit, _unconscious] remoteExecCall ["vn_mf_fnc_medical_set_unconscious", _unit];

[_unit, false] call vn_mf_fnc_medical_replicate_state;
