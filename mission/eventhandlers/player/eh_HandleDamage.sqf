params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

[_unit, _selection, _damage, _source, _projectile, _hitIndex, _instigator, _hitPoint, diag_tickTime] remoteExecCall ["vn_mf_fnc_medical_ingest_damage", 2];

_damage

