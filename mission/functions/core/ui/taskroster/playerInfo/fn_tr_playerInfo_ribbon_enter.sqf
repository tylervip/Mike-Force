/*
    File: fn_tr_playerInfo_ribbon_enter.sqf
    Author: Savage Game Design
    Modified: @dijksterhuis
    Public: No
    
    Description:
		Called by entering the Ribbon control.
		Updates the Ribbon Info Control.
    
    Parameter(s):
		0:	CONTROL		-	Control to get the "text" and other info from.
		0:	BOOL		-	CURRENTLY NOT USED
    
    Returns: nothing
    
    Example(s): none
*/


#include "..\..\..\..\..\config\ui\ui_def_base.inc"
params["_ctrl_src","_isRibbon"];
//set description text
_text = _ctrl_src getVariable ["text",""];
VN_TR_PLAYERINFO_REWARD_TEXT_CTRL ctrlSetStructuredText parseText format["<t size='0.65' >%1</t>", _text];
//set img
_ctrl_preview = VN_TR_PLAYERINFO_MEDAL_RIBBON_CTRL;
_selected_medal = _ctrl_src getVariable ["medal",""];
_ctrl_preview ctrlSetText _selected_medal;

//sizeCheck currently disabled.
_ctrl_preview ctrlCommit 0;