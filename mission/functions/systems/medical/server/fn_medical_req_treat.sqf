/*
    File: fn_medical_req_treat.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Server-validated treatment request handler.

    Parameter(s):
        _actor - Requesting player [OBJECT]
        _patient - Requested patient [OBJECT]
        _itemType - Requested item class [STRING]
        _bodyPart - Requested body part [STRING]
        _timestamp - Client request timestamp [NUMBER]

    Returns:
        None
*/

params [
    ["_actor", objNull, [objNull]],
    ["_patient", objNull, [objNull]],
    ["_itemType", "", [""]],
    ["_bodyPart", "torso", [""]],
    ["_timestamp", 0, [0]]
];

if (!isServer || isNull _actor || isNull _patient) exitWith {};
if (!alive _actor || !alive _patient) exitWith {};
if (_actor distance _patient > 3) exitWith {};
if (side _actor != side _patient) exitWith {
    ["Medical", ["You can only treat teammates."]] remoteExec ["para_c_fnc_show_notification", _actor];
};
if (vehicle _actor isNotEqualTo _actor) exitWith {
    ["Medical", ["You cannot treat while inside a vehicle."]] remoteExec ["para_c_fnc_show_notification", _actor];
};

private _owner = owner _actor;
if (_owner <= 0 || {_owner != remoteExecutedOwner}) exitWith {};

private _cooldownUntil = _actor getVariable ["vn_mf_medical_treat_cooldown", -1];
if (_cooldownUntil > serverTime) exitWith {
    ["Medical", ["Treatment is on cooldown."]] remoteExec ["para_c_fnc_show_notification", _actor];
};

if !(_itemType in ["FirstAidKit", "vn_b_item_firstaidkit", "vn_o_item_firstaidkit", "Medikit", "vn_b_item_medikit_01", "vn_o_item_medikit_01"]) exitWith {
    ["Medical", ["Unsupported medical item."]] remoteExec ["para_c_fnc_show_notification", _actor];
};

private _isMedikit = _itemType in ["Medikit", "vn_b_item_medikit_01", "vn_o_item_medikit_01"];
if (_isMedikit && {!(_actor getUnitTrait "medic")}) exitWith {
    ["Medical", ["Only medics can use medikits."]] remoteExec ["para_c_fnc_show_notification", _actor];
};

if !(_itemType in items _actor) exitWith {
    ["Medical", ["Missing required medical item."]] remoteExec ["para_c_fnc_show_notification", _actor];
};

private _state = [_patient] call vn_mf_fnc_medical_state_get;
if (count _state == 0) exitWith {};

private _wounds = _state get "wounds";
if !(_bodyPart in ["head", "torso", "arm_l", "arm_r", "leg_l", "leg_r"]) then {
    _bodyPart = "torso";
};

private _legacyKey = "";
if (_bodyPart in ["arm_l", "arm_r"]) then {
    _legacyKey = "arms";
};
if (_bodyPart in ["leg_l", "leg_r"]) then {
    _legacyKey = "legs";
};

private _before = _wounds getOrDefault [_bodyPart, if (_legacyKey isEqualTo "") then {0} else {_wounds getOrDefault [_legacyKey, 0]}];
if (_before <= 0) exitWith {
    ["Medical", ["No treatable wound on this body part."]] remoteExec ["para_c_fnc_show_notification", _actor];
};

if (!_isMedikit) then {
    _actor removeItem _itemType;
};

private _after = (_before - 0.35) max 0;
_wounds set [_bodyPart, _after];

private _head = _wounds getOrDefault ["head", 0];
private _torso = _wounds getOrDefault ["torso", 0];
private _armL = _wounds getOrDefault ["arm_l", (_wounds getOrDefault ["arms", 0])];
private _armR = _wounds getOrDefault ["arm_r", (_wounds getOrDefault ["arms", 0])];
private _legL = _wounds getOrDefault ["leg_l", (_wounds getOrDefault ["legs", 0])];
private _legR = _wounds getOrDefault ["leg_r", (_wounds getOrDefault ["legs", 0])];
private _arms = (_armL + _armR) * 0.5;
private _legs = (_legL + _legR) * 0.5;
private _bleed = ((_head * 0.45) + (_torso * 0.35) + (_arms * 0.1) + (_legs * 0.1)) min 1;
private _unconscious = (_head >= 0.95) || (_torso >= 0.95) || (_bleed >= 0.8);

_state set ["bleedingRate", _bleed];
_state set ["unconscious", _unconscious];
if (!_unconscious) then {
    _state set ["bleedoutAt", -1];
};

_patient setVariable ["vn_revive_incapacitated", _unconscious, true];
_patient setUnconscious _unconscious;
_actor setVariable ["vn_mf_medical_treat_cooldown", serverTime + 2, false];

[_patient, true] call vn_mf_fnc_medical_replicate_state;
["Medical", [format ["Applied %1 to %2.", _itemType, _bodyPart]]] remoteExec ["para_c_fnc_show_notification", _actor];
