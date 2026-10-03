/*
    File: fn_medical_open_menu.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Opens the medical silhouette menu for self or a nearby target.

    Parameter(s):
        _forceSelf - Force self-treatment mode [BOOLEAN]

    Returns:
        True when opened [BOOLEAN]
*/

params [["_forceSelf", false, [false]]];

if (!hasInterface || {!alive player}) exitWith {false};

// Already open: refresh instead of creating another dialog
if (!isNull (uiNamespace getVariable ["vn_mf_RscDisplayMedical", displayNull])) exitWith {
    [] call vn_mf_fnc_medical_dialog_refresh;
    true
};

private _patient = player;
if (!_forceSelf) then {
    private _candidate = cursorTarget;
    if (!isNull _candidate && {_candidate isKindOf "Man"} && {alive _candidate} && {player distance _candidate <= 3}) then {
        _patient = _candidate;
    };
};

uiNamespace setVariable ["vn_mf_medical_ui_patient", _patient];
uiNamespace setVariable ["vn_mf_medical_ui_selectedPart", ""];

if !(createDialog "vn_mf_RscDisplayMedical") exitWith {
    ["Medical", ["Failed to open medical menu."]] call para_c_fnc_show_notification;
    false
};

true
