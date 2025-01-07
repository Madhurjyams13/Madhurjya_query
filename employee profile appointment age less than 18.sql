SELECT 
m.dep, m.dir, COUNT(m.name)
#m.* 
FROM 
(
	SELECT 
	case 
		when dep1.hierarchy_Name = 'Finassam' 
		then dir.hierarchy_Name
		ELSE dep1.hierarchy_Name
	END AS dep,
	dir.hierarchy_Name dir,
	ddo.hierarchy_Code,
	concat(a.gpf_or_ppan_no,'') ppan, 
	CONCAT(ifnull(a.emp_First_Name,''),' ',ifnull(a.emp_last_Name,'') ) name ,
	a.dateofbirth dob, a.appoin_Date doj, 
	round(DATEDIFF(a.appoin_Date,a.dateofbirth)/365) age
	#,COUNT(*)
	FROM probityfinancials.eis_data a
	JOIN pfmaster.hierarchy_setup ddo
		ON a.ddo_Id = ddo.hierarchy_Id
	JOIN pfmaster.hierarchy_setup dep
		ON ddo.parent_hierarchy = dep.hierarchy_Id
	JOIN pfmaster.hierarchy_setup dir
		ON dep.parent_hierarchy = dir.hierarchy_Id
	JOIN pfmaster.hierarchy_setup dep1
		ON dir.parent_hierarchy = dep1.hierarchy_Id
	WHERE
	a.removed_by_ddo = 'N'	
	AND a.appoin_Date IS NOT NULL and a.dateofbirth IS NOT NULL 
	AND round(DATEDIFF(a.appoin_Date,a.dateofbirth)/365) < 18
) m
GROUP BY m.dep, m.dir
ORDER BY 1,2
