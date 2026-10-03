/*
    File: fn_medical_dialog_treat_selected.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Sends a treatment request for currently selected body part.

    Parameter(s): none

    Returns:
        None
*/

params [["_requestedItem", "auto", [""]]];
_requestedItem = toLower _requestedItem;

private _patient = uiNamespace getVariable ["vn_mf_medical_ui_patient", objNull];
if (isNull _patient || {!alive _patient}) exitWith {
    ["Medical", ["Selected patient is invalid."]] call para_c_fnc_show_notification;
};

if (player distance _patient > 3) exitWith {
    ["Medical", ["Move closer to treat this patient."]] call para_c_fnc_show_notification;
};

private _bodyPart = uiNamespace getVariable ["vn_mf_medical_ui_selectedPart", ""];
if !(_bodyPart in ["head", "torso", "arm_l", "arm_r", "leg_l", "leg_r"]) exitWith {
    ["Medical", ["Select a body part first."]] call para_c_fnc_show_notification;
};

if (_requestedItem isEqualTo "auto") then {
    _requestedItem = uiNamespace getVariable ["vn_mf_medical_ui_selectedTreatment", ""];
};
if !(_requestedItem in ["fak", "medkit"]) exitWith {
    ["Medical", ["Select a treatment item first."]] call para_c_fnc_show_notification;
};

private _medikitItems = ["Medikit", "vn_b_item_medikit_01", "vn_o_item_medikit_01"];
private _firstAidItems = ["FirstAidKit", "vn_b_item_firstaidkit", "vn_o_item_firstaidkit"];

private _findFirstOwned = {
    params ["_itemPool"];
    private _owned = "";
    {
        if (_x in (items player)) exitWith {
            _owned = _x;
        };
    } forEach _itemPool;
    _owned
};

private _itemType = "";
switch (_requestedItem) do {
    case "medkit": {
        if !(player getUnitTrait "medic") exitWith {
            ["Medical", ["Only medics can use medkits."]] call para_c_fnc_show_notification;
        };

        _itemType = [_medikitItems] call _findFirstOwned;
        if (_itemType isEqualTo "") exitWith {
            ["Medical", ["You do not have a medkit."]] call para_c_fnc_show_notification;
        };
    };

    case "fak": {
        _itemType = [_firstAidItems] call _findFirstOwned;
        if (_itemType isEqualTo "") exitWith {
            ["Medical", ["You do not have a first aid kit."]] call para_c_fnc_show_notification;
        };
    };

    default {
        if (player getUnitTrait "medic") then {
            _itemType = [_medikitItems] call _findFirstOwned;
        };

        if (_itemType isEqualTo "") then {
            _itemType = [_firstAidItems] call _findFirstOwned;
        };
    };
};

if (_itemType isEqualTo "") exitWith {
    ["Medical", ["Missing required medical item."]] call para_c_fnc_show_notification;
};

private _payload = [player, _patient, _itemType, _bodyPart, diag_tickTime];
["medical_req_treat", _payload] call para_c_fnc_call_on_server;

[] spawn {
    uiSleep 0.2;
    [] call vn_mf_fnc_medical_dialog_refresh;
};
