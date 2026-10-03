/*
    File: fn_medical_action_self_treat.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Legacy cleanup shim for old self-treat hold actions.
        Medical is now UI-only via J/Shift+J medical dialog.

    Parameter(s): none

    Returns:
        Empty action id array [ARRAY]
*/

if (!hasInterface) exitWith {-1};

if (isNil "vn_mf_medical_self_treat_actions") then {
    vn_mf_medical_self_treat_actions = [];
};

{
    [player, _x] call BIS_fnc_holdActionRemove;
} forEach vn_mf_medical_self_treat_actions;
vn_mf_medical_self_treat_actions = [];

vn_mf_medical_self_treat_actions
