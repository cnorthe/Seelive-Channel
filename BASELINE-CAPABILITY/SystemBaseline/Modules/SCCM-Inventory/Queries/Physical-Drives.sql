select 
	vgs.name0 as Name,
	vgpd.Size0 as 'Size'
from v_GS_PHYSICALDISK vgpd
join v_GS_SYSTEM vgs
    on vgpd.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'