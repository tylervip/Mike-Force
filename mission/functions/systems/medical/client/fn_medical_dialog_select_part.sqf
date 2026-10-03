/*
    File: fn_medical_dialog_select_part.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Sets the currently selected body part in the medical dialog.

    Parameter(s):
        _bodyPart - Selected body part [STRING]

    Returns:
        None
*/

params [["_bodyPart", "torso", [""]]];

if !(_bodyPart in ["head", "torso", "arm_l", "arm_r", "leg_l", "leg_r"]) exitWith {};

uiNamespace setVariable ["vn_mf_medical_ui_selectedPart", _bodyPart];
[] call vn_mf_fnc_medical_dialog_refresh;
