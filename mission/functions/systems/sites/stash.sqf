/*
    File: debug_spawn_dynamic_stash_fixed_shelter_rot.sqf
    Author: Custom / Tylervip
    Description:
        Dynamically spawns a random stash composition in front of the player:
        - Ammo boxes (1-2) with unique classes
        - 0-2 shelters (Land_vn_o_shelter_04) with fixed rotations
        - Optional campfire
        Adds debug action to delete everything.
*/

params ["_player"];
if (isNil "_player") then { _player = player };

// --- Spawn position in front of player (2 meters ahead) ---
private _forwardOffset = 2;
private _pos = _player modelToWorld [0, _forwardOffset, 0];
_pos set [2, getPosATL _player select 2]; // ensure terrain-level

// --- Function to generate a random stash composition ---
private _generateStashComposition = {
    params ["_origin"];

    private _ammoPositions = [[1.2,-1.2,0],[1.2,1.2,0],[-1.5,1.0,0],[-1.5,-1.0,0]];
    private _shelterPositions = [[-0.261719,3.49219,0],[-0.447266,-3.49658,0],[-3.68164,0.0488281,0]];
    private _shelterRotations = [86.7544,271.788,0];

    private _composition = [];

    // --- Ammo boxes (1-2) with unique classes ---
    private _ammoClasses = ["vn_o_ammobox_03","vn_o_ammobox_04","vn_o_ammobox_02"];
    private _numAmmo = 1 + floor random 2;
    private _availablePositions = [0,1,2,3];
    for "_i" from 1 to _numAmmo do {
        // Pick a unique class
        private _classIndex = floor random count _ammoClasses;
        private _class = _ammoClasses select _classIndex;
        _ammoClasses = _ammoClasses - [_class]; // remove to prevent duplicate class

        // Pick a unique position
        private _posIndex = selectRandom _availablePositions;
        _availablePositions = _availablePositions - [_posIndex];

        private _basePos = _ammoPositions select _posIndex;
        private _offsetPos = [
            (_basePos select 0) + (random 0.3 - 0.15),
            (_basePos select 1) + (random 0.3 - 0.15),
            0
        ];

        _composition pushBack [_class,_offsetPos,random 360,1,0,[0,0],"","",true,false];
    };

    // 10% chance for special ammo box
    if (random 1 < 0.1 && !("vn_o_ammobox_05" in _ammoClasses)) then {
        private _specialClass = "vn_o_ammobox_05";
        private _posIndex = selectRandom [0,1,2,3];
        private _basePos = _ammoPositions select _posIndex;
        private _offsetPos = [
            (_basePos select 0) + (random 0.3 - 0.15),
            (_basePos select 1) + (random 0.3 - 0.15),
            0
        ];
        _composition pushBack [_specialClass,_offsetPos,random 360,1,0,[0,0],"","",true,false];
    };

    // --- Shelters (0-2) with fixed rotations ---
    private _numShelters = floor random 3; // 0,1,2
    private _usedShelters = [];
    for "_i" from 1 to _numShelters do {
        private _posIndex = selectRandom [0,1,2];
        while {_usedShelters find _posIndex != -1} do { _posIndex = selectRandom [0,1,2]; };
        _usedShelters pushBack _posIndex;

        private _offsetPos = _shelterPositions select _posIndex;
        private _yaw = _shelterRotations select _posIndex;

        private _shelterClass = "Land_vn_o_shelter_04";
        _composition pushBack [_shelterClass,_offsetPos,_yaw,1,0,[0,0],"","",true,false];
    };

    // --- Optional campfire (50% chance) ---
    if (random 1 < 0.5) then {
        private _fireType = if (random 1 < 0.5) then {"Land_vn_campfire_f"} else {"vn_campfire_burning_f"};
        private _fireOffset = [
            (random 1.2 - 0.6),
            (random 1.2 - 0.6),
            0
        ];
        _composition pushBack [_fireType,_fireOffset,random 360,1,0,[0,0],"","",true,false];
    };

    _composition
};

// --- Generate and spawn ---
private _comp = [_pos] call _generateStashComposition;
private _spawnedObjs = [_pos, getDir _player, _comp] call BIS_fnc_ObjectsMapper;

// --- Add debug action to delete everything ---
_player addAction [
    "Delete Spawned Stash",
    {
        params ["_target", "_caller", "_actionId", "_args"];
        private _objs = _args;
        { deleteVehicle _x } forEach _objs;
        _caller removeAction _actionId;
    },
    _spawnedObjs
];
