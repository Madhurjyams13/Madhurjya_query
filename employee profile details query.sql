SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS dep,
dir.hierarchy_Name dir, 
COUNT(*), COUNT(*) - COUNT(a.dob), COUNT(*) - COUNT(a.appoin_Date),
COUNT(*) - COUNT(a.retirement_age), COUNT(*) - COUNT(a.pan_No),
SUM(case when a.spouse_Name IS NULL then 1 ELSE 0 END AND a.marital_Status = 'M')
#dep.hierarchy_Name, dir.hierarchy_Name, 
#a.* 
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
GROUP BY  case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END, dir.hierarchy_Name
ORDER BY 1,2
#LIMIT 0,10
;


SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END AS dep,
dir.hierarchy_Name dir, 

COUNT(*)#, COUNT(*) - COUNT(a.dob), COUNT(*) - COUNT(a.appoin_Date),
#COUNT(*) - COUNT(a.retirement_age), COUNT(*) - COUNT(a.pan_No),
#SUM(case when a.spouse_Name IS NULL then 1 ELSE 0 END AND a.marital_Status = 'M')
#dep.hierarchy_Name, dir.hierarchy_Name, 
#a.* 
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
AND ( a.dob IS NULL 
	OR a.appoin_Date IS NULL 
	OR a.retirement_age IS NULL 
	OR a.pan_No IS NULL  
	OR (a.marital_Status = 'M' AND a.spouse_Name IS NULL )
	)
GROUP BY  case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END, dir.hierarchy_Name
ORDER BY 1,2;
#LIMIT 0,10

SELECT m.*, n.* FROM 
(
SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS dep,
dir.hierarchy_Name dir, 
COUNT(*), COUNT(*) - COUNT(a.dob), COUNT(*) - COUNT(a.appoin_Date),
COUNT(*) - COUNT(a.retirement_age), COUNT(*) - COUNT(a.pan_No),
SUM(case when a.spouse_Name IS NULL then 1 ELSE 0 END AND a.marital_Status = 'M')
#dep.hierarchy_Name, dir.hierarchy_Name, 
#a.* 
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
GROUP BY  case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END, dir.hierarchy_Name

) m

LEFT JOIN 

(

SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END AS dep,
dir.hierarchy_Name dir, 

COUNT(*)#, COUNT(*) - COUNT(a.dob), COUNT(*) - COUNT(a.appoin_Date),
#COUNT(*) - COUNT(a.retirement_age), COUNT(*) - COUNT(a.pan_No),
#SUM(case when a.spouse_Name IS NULL then 1 ELSE 0 END AND a.marital_Status = 'M')
#dep.hierarchy_Name, dir.hierarchy_Name, 
#a.* 
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
AND ( a.dob IS NULL 
	OR a.appoin_Date IS NULL 
	OR a.retirement_age IS NULL 
	OR a.pan_No IS NULL  
	OR (a.marital_Status = 'M' AND a.spouse_Name IS NULL )
	)
GROUP BY  case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name
END, dir.hierarchy_Name
ORDER BY 1,2
) n

ON m.dep = n.dep
AND m.dir = n.dir