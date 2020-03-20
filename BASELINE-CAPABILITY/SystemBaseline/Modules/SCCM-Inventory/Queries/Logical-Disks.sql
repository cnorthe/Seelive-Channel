select 
	vgs.name0 as Name,
	vgld.Caption0 as 'Drive Letter',
	vgld.FileSystem0 as 'File System',
	vgld.Size0 as 'Size'
from v_GS_LOGICAL_DISK vgld
join v_GS_SYSTEM vgs
    on vgld.ResourceID = vgs.ResourceID
where vgs.SystemRole0 = 'Server'
AND vgld.Caption0 is not null