/*
    File: fn_medical_set_unconscious.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Applies the unconscious state to a unit. setUnconscious and setCaptive need a local
        unit, so the server dispatches this to the unit's owner.

    Parameter(s):
        _unit - Unit to affect [OBJECT]
        _state - Unconscious state [BOOLEAN]

    Returns:
        None
*/

params [["_unit", objNull, [objNull]], ["_state", true, [true]]];

if (isNull _unit || {!local _unit}) exitWith {};

_unit setUnconscious _state;
_unit setCaptive _state;

if (!_state && {currentWeapon _unit isEqualTo "" || {currentWeapon _unit isEqualTo binocular _unit}}) then {
    // Prevent being stuck in the unconscious animation without a weapon
    _unit playMoveNow "UnconsciousOutProne";
};
