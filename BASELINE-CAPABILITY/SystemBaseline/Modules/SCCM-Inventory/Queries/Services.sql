select 
	vgs.name0 as Name,
	vgsvc.Name0 as 'Service Name',
	vgsvc.DisplayName0 as 'Display Name',
	vgsvc.StartMode0 as 'Start Mode',
	vgsvc.StartName0 as 'Start Name'
from v_GS_SERVICE vgsvc
join v_GS_SYSTEM vgs
    on vgsvc.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'
AND vgsvc.StartName0 is not null