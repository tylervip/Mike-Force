/*
    File: fn_medical_apply_treatment_damage.sqf
    Author: Tylervip
    Public: No

    Description:
        Reduces the patient's local engine hitpoint damage after server-approved treatment.

    Parameter(s):
        _patient - Treated unit [OBJECT]
        _bodyPart - Treated medical body part [STRING]
        _amount - Damage to remove [NUMBER]

    Returns:
        None
*/

params [
    ["_patient", objNull, [objNull]],
    ["_bodyPart", "", [""]],
    ["_amount", 0, [0]]
];

if (!isServer && {remoteExecutedOwner != 2}) exitWith {};
if (isNull _patient || {!local _patient}) exitWith {};
if !(_bodyPart in ["head", "torso", "arm_l", "arm_r", "leg_l", "leg_r"]) exitWith {};

private _hitPoints = getAllHitPointsDamage _patient;
if (_hitPoints isEqualTo []) exitWith {};

private _hitPointNames = _hitPoints select 0;
private _hitPointDamages = _hitPoints select 2;
private _candidateHitPoints = [];

{
    private _hitPointName = toLower _x;
    private _mappedPart = [_x] call vn_mf_fnc_medical_map_hitpoint_to_bodypart;
    private _isAnatomicalHitPoint = (
        (_hitPointName find "head" >= 0)
        || {_hitPointName find "face" >= 0}
        || {_hitPointName find "neck" >= 0}
        || {_hitPointName find "arm" >= 0}
        || {_hitPointName find "hand" >= 0}
        || {_hitPointName find "leg" >= 0}
        || {_hitPointName find "foot" >= 0}
        || {_hitPointName find "pelvis" >= 0}
        || {_hitPointName find "spine" >= 0}
        || {_hitPointName find "diaphragm" >= 0}
        || {_hitPointName find "chest" >= 0}
        || {_hitPointName find "abdomen" >= 0}
    );
    private _matchesBodyPart = switch (_bodyPart) do {
        case "head": {_mappedPart isEqualTo "head"};
        case "torso": {_mappedPart isEqualTo "torso"};
        case "arm_l";
        case "arm_r": {_mappedPart in ["arm_l", "arm_r"]};
        case "leg_l";
        case "leg_r": {_mappedPart in ["leg_l", "leg_r"]};
        default {false};
    };

    if (_isAnatomicalHitPoint && {_matchesBodyPart}) then {
        _candidateHitPoints pushBack [_hitPointDamages select _forEachIndex, _x];
    };
} forEach _hitPointNames;

if (_candidateHitPoints isEqualTo []) exitWith {};
_candidateHitPoints sort false;
(_candidateHitPoints select 0) params ["_highestDamage", "_hitPointName"];

private _newDamage = (_highestDamage - (_amount max 0 min 0.35)) max 0;
_patient setHitPointDamage [_hitPointName, _newDamage];
