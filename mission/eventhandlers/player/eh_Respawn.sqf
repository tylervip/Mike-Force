/*
    File: eh_Respawn.sqf
    Author: Savage Game Design
    Public: No

    Description:
	    Respawn Event Handler.

    Parameter(s):
        _unit - Alive Player [OBJECT, defaults to DEFAULTVALUE]
        _corpse - Dead Player [OBJECT, defaults to DEFAULTVALUE]

    Returns: nothing

    Example(s):
	    Not called directly.
*/

params
[
	"_unit",
	"_corpse"
];


// restart master loop
0 spawn para_c_fnc_compiled_loop_init;

// TODO Remove Medical Conditions (attributes)
["eatdrink", [0,0,"remove_attributes"]] call para_c_fnc_call_on_server;

_unit setVariable ["vn_mf_side", side player, true];

// update UI
["vn_mf_db_thirst",1] call vn_mf_fnc_ui_update;
["vn_mf_db_hunger",1] call vn_mf_fnc_ui_update;

// re-add hold/add actions onto the newly respawned player
call vn_mf_fnc_action_init;

[player] call vn_mf_fnc_curator_init;

// reset the emotes menu setup because player object has now changed!
[player] call vn_mf_fnc_emotes_init;
