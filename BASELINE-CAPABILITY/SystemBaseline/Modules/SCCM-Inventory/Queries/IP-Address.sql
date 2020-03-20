select 
	vgs.name0 as Name,
	vrsi.IP_Addresses0 as 'IP Address'
from v_RA_System_IPAddresses vrsi
join v_GS_SYSTEM vgs
    on vrsi.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'