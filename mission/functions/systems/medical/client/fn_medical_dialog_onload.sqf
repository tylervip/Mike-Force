/*
    File: fn_medical_dialog_onload.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Initializes the medical dialog while preserving the chosen treatment item.

    Parameter(s):
        _display - Display [DISPLAY]

    Returns:
        None
*/

params ["_display"];
uiNamespace setVariable ["vn_mf_RscDisplayMedical", _display];
uiNamespace setVariable ["vn_mf_medical_ui_selectedPart", ""];
[] spawn {
    uiSleep 0;
    [] call vn_mf_fnc_medical_dialog_refresh;
};
