select 
	vgs.name0 as Name,
	vgos.Caption0 as OS,
	garp.DisplayName0 as 'Display Name',
	'32' as Architecture
	from v_GS_ADD_REMOVE_PROGRAMS garp
join v_GS_SYSTEM vgs
    on garp.ResourceID = vgs.ResourceID
join v_GS_OPERATING_SYSTEM vgos
	on garp.ResourceID = vgos.ResourceID
where vgs.SystemRole0 = 'Server'
AND garp.DisplayName0 is not null
union
select 
	vgs.name0 as Name,
	vgos.Caption0 as OS,
	garp64.DisplayName0 as 'Display Name',
	'64' as Architecture
	from v_GS_ADD_REMOVE_PROGRAMS_64 garp64
join v_GS_SYSTEM vgs
    on garp64.ResourceID = vgs.ResourceID
join v_GS_OPERATING_SYSTEM vgos
	on garp64.ResourceID = vgos.ResourceID
where vgs.SystemRole0 = 'Server'
AND garp64.DisplayName0 is not null