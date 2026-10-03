/*
    File: fn_medical_state_default.sqf
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
    Public: No

    Description:
        Creates a default medical state hash map.

    Parameter(s): none

    Returns:
        Medical state [HASHMAP]
*/

private _wounds = createHashMapFromArray [
    ["head", 0],
    ["torso", 0],
    ["arm_l", 0],
    ["arm_r", 0],
    ["leg_l", 0],
    ["leg_r", 0]
];

createHashMapFromArray [
    ["wounds", _wounds],
    ["bleedingRate", 0],
    ["pain", 0],
    ["unconscious", false],
    ["lastDamageAt", -1],
    ["bleedoutAt", -1],
    ["lastReplicatedAt", -1]
]
