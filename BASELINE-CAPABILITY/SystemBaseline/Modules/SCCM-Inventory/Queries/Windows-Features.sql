select 
	vgs.name0 as Name,
	vgof.Caption0 as 'Display Name',
	vgof.Name0 as 'Product ID'
from v_GS_OPTIONAL_FEATURE vgof
join v_GS_SYSTEM vgs
    on vgof.ResourceID = vgs.ResourceID
where vgof.InstallState0 = 1
AND vgs.SystemRole0 = 'Server'