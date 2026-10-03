/*
    File: fn_medical_dialog_refresh.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Refreshes medical dialog contents and selection highlight.

    Parameter(s): none

    Returns:
        None
*/

private _IDC_TITLE = 120;
private _IDC_SELECTED_LABEL = 121;
private _IDC_WOUNDS_TEXT = 122;
private _IDC_PART_HEAD = 130;
private _IDC_PART_TORSO = 131;
private _IDC_PART_ARM_L = 132;
private _IDC_PART_ARM_R = 133;
private _IDC_PART_LEG_L = 134;
private _IDC_PART_LEG_R = 135;
private _IDC_TREATMENT_FAK = 150;
private _IDC_TREATMENT_MEDKIT = 151;
private _IDC_TREATMENT_FAK_BG = 155;
private _IDC_TREATMENT_MEDKIT_BG = 156;

private _display = uiNamespace getVariable ["vn_mf_RscDisplayMedical", displayNull];
if (isNull _display) exitWith {};

private _patient = uiNamespace getVariable ["vn_mf_medical_ui_patient", objNull];
if (isNull _patient) then {
    _patient = player;
    uiNamespace setVariable ["vn_mf_medical_ui_patient", _patient];
};

private _selected = uiNamespace getVariable ["vn_mf_medical_ui_selectedPart", ""];
private _hasSelection = _selected in ["head", "torso", "arm_l", "arm_r", "leg_l", "leg_r"];
if (!_hasSelection) then {
    _selected = "";
    uiNamespace setVariable ["vn_mf_medical_ui_selectedPart", _selected];
};

private _titleCtrl = _display displayCtrl _IDC_TITLE;
private _selectedCtrl = _display displayCtrl _IDC_SELECTED_LABEL;
private _woundsCtrl = _display displayCtrl _IDC_WOUNDS_TEXT;

private _modeText = if (_patient isEqualTo player) then {"Self"} else {"Buddy"};
_titleCtrl ctrlSetText format ["Medical - %1 (%2)", name _patient, _modeText];

private _parts = ["head", "torso", "arm_l", "arm_r", "leg_l", "leg_r"];
private _partLabels = ["Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"];
private _partIndex = _parts find _selected;
if (_partIndex < 0) then {
    _selectedCtrl ctrlSetText "Selected: -";
} else {
    _selectedCtrl ctrlSetText format ["Selected: %1", _partLabels select _partIndex];
};

private _wounds = _patient getVariable ["vn_mf_medical_wounds", [0,0,0,0,0,0]];
private _bleedingRate = _patient getVariable ["vn_mf_medical_bleedingRate", 0];
private _unconscious = _patient getVariable ["vn_mf_medical_unconscious", false];

private _healthText = format [
    "<t size='0.9'>Head: %1<br/>Torso: %2<br/>Left Arm: %3<br/>Right Arm: %4<br/>Left Leg: %5<br/>Right Leg: %6<br/><br/>Bleeding: %7<br/>Unconscious: %8</t>",
    ((_wounds select 0) * 100) toFixed 0,
    ((_wounds select 1) * 100) toFixed 0,
    ((_wounds select 2) * 100) toFixed 0,
    ((_wounds select 3) * 100) toFixed 0,
    ((_wounds select 4) * 100) toFixed 0,
    ((_wounds select 5) * 100) toFixed 0,
    (_bleedingRate * 100) toFixed 0,
    if (_unconscious) then {"Yes"} else {"No"}
];
_woundsCtrl ctrlSetStructuredText parseText _healthText;

private _partControlIds = [
    _IDC_PART_HEAD,
    _IDC_PART_TORSO,
    _IDC_PART_ARM_L,
    _IDC_PART_ARM_R,
    _IDC_PART_LEG_L,
    _IDC_PART_LEG_R
];

{
    private _ctrl = _display displayCtrl _x;
    _ctrl ctrlSetTextColor [1, 1, 1, 0.6];
} forEach _partControlIds;
if (_partIndex >= 0) then {
    private _selectedCtrlPart = _display displayCtrl (_partControlIds select _partIndex);
    _selectedCtrlPart ctrlSetTextColor [0.2, 1, 1, 1];
};

private _selectedTreatment = uiNamespace getVariable ["vn_mf_medical_ui_selectedTreatment", ""];
private _fakCtrl = _display displayCtrl _IDC_TREATMENT_FAK;
private _medkitCtrl = _display displayCtrl _IDC_TREATMENT_MEDKIT;
private _fakBackgroundCtrl = _display displayCtrl _IDC_TREATMENT_FAK_BG;
private _medkitBackgroundCtrl = _display displayCtrl _IDC_TREATMENT_MEDKIT_BG;

private _medikitItems = ["Medikit", "vn_b_item_medikit_01", "vn_o_item_medikit_01"];
private _firstAidItems = ["FirstAidKit", "vn_b_item_firstaidkit", "vn_o_item_firstaidkit"];
private _inventory = items player;
private _medkitCount = count (_inventory select {_x in _medikitItems});
private _firstAidCount = count (_inventory select {_x in _firstAidItems});

_fakCtrl ctrlSetText format ["First Aid Kit (%1)", _firstAidCount];
_medkitCtrl ctrlSetText format ["Medkit (%1)", _medkitCount];

_fakBackgroundCtrl ctrlSetBackgroundColor (if (_selectedTreatment isEqualTo "fak") then {[0.08, 0.48, 0.16, 0.95]} else {[0.15, 0.15, 0.15, 0.95]});
_medkitBackgroundCtrl ctrlSetBackgroundColor (if (_selectedTreatment isEqualTo "medkit") then {[0.08, 0.48, 0.16, 0.95]} else {[0.15, 0.15, 0.15, 0.95]});
