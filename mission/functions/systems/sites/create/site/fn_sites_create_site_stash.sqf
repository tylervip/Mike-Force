/*
    File: fn_sites_create_site_stash.sqf
    Author: Tylervip
    Public: No
    
    Description:
        Creates a hidden enemy supply stash site.
        Smaller than a camp, focused on destroyable cache objects.

    Parameter(s):
        _pos - Position to spawn the stash site at

    Returns:
        Function reached the end [BOOL]
*/

params ["_pos"];
[
    "stash",
    _pos,
    "factory",
    {
        params ["_siteStore"];

        private _spawnPos = getPos _siteStore;

        // Spawn dynamic stash composition
        private _stashObjs = [_spawnPos] call vn_mf_fnc_sites_create_compositions_stash;
        vn_site_objects append _stashObjs;
        
        // Determine which objects can be destroyed
        private _stashObjectiveTypes = [
            "vn_o_ammobox_02", //magazines
            "vn_o_ammobox_03", //rockets
            "vn_o_ammobox_04", //weapons
            "vn_o_ammobox_05" //mixed
        ];

        // Apply loot to each matching box
        // {
        //     private _crate = _x;                           // The actual ammo box object
        //     private _crateType = typeOf _crate;            // e.g., "vn_o_ammobox_02"
        //     private _crateData = missionConfigFile >> "gamemode" >> "StashLoot" >> "AmmoBoxes" >> _crateType;

        //     if (!isClass _crateData) exitWith {};

        //     { _crate addMagazineCargoGlobal _x } forEach getArray(_crateData >> "magazines");
        //     { _crate addWeaponCargoGlobal _x } forEach getArray(_crateData >> "weapons");
        //     { _crate addItemCargoGlobal _x } forEach getArray(_crateData >> "items");
        //     { _crate addBackpackCargoGlobal _x } forEach getArray(_crateData >> "backpacks");

        // } forEach (_stashObjs select {typeOf _x in _stashObjectiveTypes});



        // Store objects to destroy
        private _objectsToDestroy = _stashObjs select {typeOf _x in _stashObjectiveTypes};


        // --- Marker setup ---
        private _markerPos = _spawnPos getPos [10 + random 20, random 360];
        private _stashMarker = createMarker [format ["Stash_%1", _siteId], _markerPos];
        _stashMarker setMarkerType "o_unknown";
        _stashMarker setMarkerText "Stash Site";
        _stashMarker setMarkerAlpha 0;

        private _partialMarkerPos = _spawnPos getPos [10 + random 40, random 360];
        private _markerPartial = createMarker [format ["PartialStash_%1", _siteId], _partialMarkerPos];
        _markerPartial setMarkerType "o_unknown";
        _markerPartial setMarkerAlpha 0;

        // Normalize buildings
        _stashObjs select {_x isKindOf "Building"} apply {
            [_x] call vn_mf_fnc_sites_utils_normalise_object_placement;
        };

        // Small chance of light ambush
        if (random 1 < 0.2) then {
            _siteStore setVariable [
                "aiObjectives",
                [[_spawnPos, 0.3, 0.6] call para_s_fnc_ai_obj_request_ambush]
            ];
        };

        // Store for later use
        _siteStore setVariable ["markers", [_stashMarker]];
        _siteStore setVariable ["partialMarkers", [_markerPartial]];
        _siteStore setVariable ["objectsToDestroy", _objectsToDestroy];
	},
	//Teardown condition check code
	{
		//Check if we need to teardown every 15 seconds.
		15 call _fnc_periodicallyAttemptTeardown;
	},
	//Teardown condition
	{
		params ["_siteStore"];
		[_siteStore] call vn_mf_fnc_sites_utils_std_check_teardown;
	},
	//Teardown code
	{
		params ["_siteStore"];
		[_siteStore] call vn_mf_fnc_sites_utils_std_teardown;
	}
] call vn_mf_fnc_sites_create_site;
