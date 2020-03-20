select 
	vgs.name0 as Name,
	vgpm.Capacity0 as 'Capacity'
from v_GS_PHYSICAL_MEMORY vgpm
join v_GS_SYSTEM vgs
    on vgpm.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'