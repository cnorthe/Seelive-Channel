select 
	vgs.name0 as Name,
	vgp.NumberOfCores0 as 'Cores',
	vgp.NumberOfLogicalProcessors0 as 'Logical Processors'
from v_GS_PROCESSOR vgp
join v_GS_SYSTEM vgs
    on vgp.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'