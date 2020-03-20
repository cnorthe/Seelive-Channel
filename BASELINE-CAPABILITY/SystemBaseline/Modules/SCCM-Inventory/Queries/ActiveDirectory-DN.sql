select 
    vrs.name0 as Name,
	vrs.Distinguished_Name0 as DN
from v_r_system vrs
join v_GS_SYSTEM vgs
	on vrs.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'