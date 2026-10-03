/*
    File: fn_medical_map_hitpoint_to_bodypart.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Maps Arma hit point names to the v1 medical body-part buckets.

    Parameter(s):
        _hitPoint - Hit point name from HandleDamage [STRING]

    Returns:
        Body part key [STRING]
*/

params [["_hitPoint", "", [""]]];

private _lower = toLower _hitPoint;
if (_lower find "head" >= 0) exitWith {"head"};
if (_lower find "face" >= 0) exitWith {"head"};
if (_lower find "leftarm" >= 0) exitWith {"arm_l"};
if (_lower find "rightarm" >= 0) exitWith {"arm_r"};
if (_lower find "lefthand" >= 0) exitWith {"arm_l"};
if (_lower find "righthand" >= 0) exitWith {"arm_r"};
if (_lower find "leftleg" >= 0) exitWith {"leg_l"};
if (_lower find "rightleg" >= 0) exitWith {"leg_r"};
if (_lower find "leftfoot" >= 0) exitWith {"leg_l"};
if (_lower find "rightfoot" >= 0) exitWith {"leg_r"};
if (_lower find "arm" >= 0) exitWith {"arm_l"};
if (_lower find "hand" >= 0) exitWith {"arm_l"};
if (_lower find "leg" >= 0) exitWith {"leg_l"};
if (_lower find "foot" >= 0) exitWith {"leg_l"};
if (_lower find "pelvis" >= 0) exitWith {"torso"};
if (_lower find "spine" >= 0) exitWith {"torso"};
if (_lower find "body" >= 0) exitWith {"torso"};
if (_lower find "diaphragm" >= 0) exitWith {"torso"};
if (_lower find "chest" >= 0) exitWith {"torso"};

"torso"
