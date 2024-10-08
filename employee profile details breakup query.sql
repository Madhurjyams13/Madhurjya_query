SELECT m.* FROM 
(
SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS dep,
dir.hierarchy_Name dir, 
ddo.hierarchy_Code,
#COUNT(*), COUNT(*) - COUNT(a.dob), COUNT(*) - COUNT(a.appoin_Date),
#COUNT(*) - COUNT(a.retirement_age), COUNT(*) - COUNT(a.pan_No),
#SUM(case when a.spouse_Name IS NULL then 1 ELSE 0 END AND a.marital_Status = 'M')
#dep.hierarchy_Name, dir.hierarchy_Name, 
#a.* 
concat(a.gpf_or_ppan_no,''), 
CONCAT(ifnull(a.emp_First_Name,''),' ',ifnull(a.emp_last_Name,'') ) ,
a.dob, a.appoin_Date, a.retirement_age, a.pan_No, a.marital_Status, a.spouse_Name
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
/*GROUP BY  case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END, dir.hierarchy_Name*/
AND ( a.dob IS NULL 
	OR a.appoin_Date IS NULL 
	OR a.retirement_age IS NULL 
	OR a.pan_No IS NULL  
	OR (a.marital_Status = 'M' AND a.spouse_Name IS NULL )
	)
) m
WHERE
m.dep = 'Finance Department'

ORDER BY 1,2,3