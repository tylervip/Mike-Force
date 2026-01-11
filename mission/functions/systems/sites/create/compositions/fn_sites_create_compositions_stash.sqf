/*
    File: vn_mf_fnc_sites_create_compositions_stash.sqf
    Author: Tylervip
    Public: Yes

    Description:
        Dynamically generates a random stash composition with ammo boxes,
        shelters (Land_vn_o_shelter_04) with fixed rotations, and optional campfire.

    Parameter(s):
        _position - Position of the stash [Position3D]

    Returns:
        Array of spawned stash objects [Array]
*/

params ["_pos"];

private _composition = [];

// ---------------- AMMO ----------------
private _ammoPositions = [
    [ 1.2,-1.2,0],
    [ 1.2, 1.2,0],
    [-1.5, 1.0,0],
    [-1.5,-1.0,0]
];

//add coustom invtory to each box
private _ammoClasses = [
    "vn_o_ammobox_02",
    "vn_o_ammobox_03",
    "vn_o_ammobox_04",
    "vn_o_ammobox_05"
];

private _numAmmo = 1 + floor random 2;
private _usedAmmoClasses = [];
private _usedAmmoPositions = [];

for "_i" from 1 to _numAmmo do {
    private _cls = selectRandom (_ammoClasses - _usedAmmoClasses);
    _usedAmmoClasses pushBack _cls;

    private _idx = selectRandom ([0,1,2,3] - _usedAmmoPositions);
    _usedAmmoPositions pushBack _idx;

    private _p = _ammoPositions select _idx;

    _composition pushBack [
        _cls,
        [_p#0 + random 0.2 - 0.1, _p#1 + random 0.2 - 0.1, 0],
        random 360,
        1,0,[],"","",true,false
    ];
};

// ---------------- SHELTERS ----------------
private _shelterData = [
    [[-0.261719,  3.49219, 0],  86.7544],
    [[-0.447266, -3.49658,0], 271.788],
    [[-3.68164,   0.0488281,0], 0]
];

private _numShelters = floor random 3;
private _usedShelters = [];

for "_i" from 1 to _numShelters do {
    private _idx = selectRandom ([0,1,2] - _usedShelters);
    _usedShelters pushBack _idx;

    private _data = _shelterData select _idx;

    _composition pushBack [
        "Land_vn_o_shelter_04",
        _data#0,
        _data#1,
        1,0,[],"","",true,false
    ];
};

// ---------------- CAMPFIRE ----------------
if (random 1 < 0.5) then {
    _composition pushBack [
        "Land_vn_campfire_f",
        [random 0.6 - 0.3, random 0.6 - 0.3, 0],
        0,1,0,[],"","",true,false
    ];
};

// ---------------- SPAWN & RETURN OBJECTS ----------------
private _spawnedObjects = [_pos, random 360, _composition] call BIS_fnc_ObjectsMapper;
_spawnedObjects
