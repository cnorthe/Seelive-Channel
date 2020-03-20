select 
	vgs.name0 as Name,
	vgie.ExecutableName0 as Executable
from v_GS_INSTALLED_EXECUTABLE vgie
join v_GS_SYSTEM vgs
    on vgie.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'
AND vgie.ExecutableName0 is not null