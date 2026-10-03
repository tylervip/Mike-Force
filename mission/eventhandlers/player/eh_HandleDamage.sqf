// Wrapped in call so exitWith returns its value to the engine from an event handler string
_this call {
params [
    "_unit",
    "_selection",
    "_damage",
    "_source",
    "_projectile",
    "_hitIndex",
    "_instigator",
    "_hitPoint",
    ["_directHit", false, [false]]
];

if (!local _unit) exitWith {_damage};
diag_log format ["[MEDDBG] hp=%1 sel=%2 dmg=%3 proj=%4 direct=%5 src=%6 total=%7 life=%8", _hitPoint, _selection, _damage, _projectile, _directHit, _source, damage _unit, lifeState _unit];

private _hitPointName = toLower (if (_hitPoint isEqualTo "") then {"#structural"} else {_hitPoint});
private _currentDamage = if (_hitPointName isEqualTo "#structural") then {
    damage _unit
} else {
    if (_hitIndex >= 0) then {_unit getHitIndex _hitIndex} else {_unit getHitPointDamage _hitPoint};
};

if (!isDamageAllowed _unit) exitWith {_currentDamage};
if (!alive _unit) exitWith {_damage};
if (
    _unit getVariable ["vn_mf_medical_unconscious", false]
    || {_unit getVariable ["vn_revive_incapacitated", false]}
) exitWith {_currentDamage};

if (_hitPointName isEqualTo "incapacitated") exitWith {
    [
        _unit, _selection, _damage, _source, _projectile, _hitIndex,
        _instigator, _hitPoint, diag_tickTime, false
    ] remoteExecCall ["vn_mf_fnc_medical_ingest_damage", 2];
    _currentDamage
};

private _hitDamage = _damage - _currentDamage;
if (_hitDamage <= 0) exitWith {_damage};

private _medicalBodyHitPoints = [
    "hitface", "hitneck", "hithead",
    "hitarms", "hithands",
    "hitbody", "hitpelvis", "hitabdomen", "hitdiaphragm", "hitchest",
    "hitlegs"
];
if !(_hitPointName in _medicalBodyHitPoints) exitWith {_currentDamage};

// Engine hitpoint damage is never applied. Hits become wound increments handled by the medical system,
// so a single hit cannot kill. Returning the pre-hit value blocks the engine damage.
private _isAmbientFire = (
    !_directHit
    && {_projectile isEqualTo ""}
    && {(isNull _instigator || {isNull _source})}
);

if (_isAmbientFire) exitWith {
    private _accumulatedAt = _unit getVariable ["vn_mf_medical_fire_accumulated_at", -1];
    private _accumulatedDamage = _unit getVariable ["vn_mf_medical_fire_accumulated", createHashMap];
    if (_accumulatedAt < 0 || {serverTime - _accumulatedAt > 30}) then {
        _accumulatedDamage = createHashMap;
    };

    // Batch low-rate fire damage; one light wound per threshold crossed.
    private _hitPointAccumulatedDamage = (_accumulatedDamage getOrDefault [_hitPointName, 0]) + _hitDamage;
    _unit setVariable ["vn_mf_medical_fire_accumulated_at", serverTime];
    if (_hitPointAccumulatedDamage > 0.75) then {
        _hitPointAccumulatedDamage = 0;
        [_unit, _selection, 1, _source, _projectile, _hitIndex, _instigator, _hitPoint] spawn vn_mf_fnc_medical_send_wound;
    };
    _accumulatedDamage set [_hitPointName, _hitPointAccumulatedDamage];
    _unit setVariable ["vn_mf_medical_fire_accumulated", _accumulatedDamage];
    _currentDamage
};

if (_hitPointName isEqualTo "hitbody") exitWith {_currentDamage};
if (_projectile isEqualTo "" && {isNull _source}) exitWith {_currentDamage};
if (_hitDamage < ([0.3, 0.001] select _directHit)) exitWith {_currentDamage};

private _armor = getNumber (configOf _unit >> "HitPoints" >> _hitPoint >> "armor");
private _normalizedDamage = _hitDamage * _armor;

// One bullet raises several hitpoint events in the same frame; collect them and apply once.
private _pendingHits = _unit getVariable "vn_mf_medical_pending_hits";
if (isNil "_pendingHits") then {
    _pendingHits = [];
    _unit setVariable ["vn_mf_medical_pending_hits", _pendingHits];
    [_unit, _source, _projectile, _instigator] spawn {
        params ["_unit", "_source", "_projectile", "_instigator"];
        sleep 0;
        private _hits = _unit getVariable ["vn_mf_medical_pending_hits", []];
        _unit setVariable ["vn_mf_medical_pending_hits", nil];
        if (_hits isEqualTo []) exitWith {};
        _hits sort false;
        {
            _x params ["_normalizedDamage", "_hitPoint", "_selection", "_hitIndex", "_directHit"];
            private _tier = 1;
            private _midThreshold = [4, 3] select (_hitPoint in ["hitarms", "hithands"]);
            private _highThreshold = [8, 6] select (_hitPoint in ["hitarms", "hithands"]);
            if (_normalizedDamage > _highThreshold) then {
                _tier = 3;
            } else {
                if (_normalizedDamage > _midThreshold) then {_tier = 2};
            };
            [_unit, _selection, _tier, _source, _projectile, _hitIndex, _instigator, _hitPoint] call vn_mf_fnc_medical_send_wound;
            // Direct hit: the hitpoint with the most damage took the bullet.
            if (_directHit) exitWith {};
        } forEach _hits;
    };
};
_pendingHits pushBack [_normalizedDamage, _hitPoint, _selection, _hitIndex, _directHit];

_currentDamage
}
