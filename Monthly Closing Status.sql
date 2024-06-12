SELECT a.hierarchy_Name,
case 
	when ag1.submitted_on IS NULL then 'Not Submitted'
		ELSE CONCAT('Submitted on ', DATE(ag1.submitted_on) ) 
	END AS STATUS
FROM pfmaster.hierarchy_setup a 
LEFT JOIN  
(
	SELECT ag.treasury , t.hierarchy_Name AS TREASURY1,
	ag.month , ag.year, 
	ag.submitted_on 
	FROM ag_submission.ag_submission_details ag 
	left join pfmaster.hierarchy_setup as t 
	on t.hierarchy_Id=ag.treasury  
	where 
	ag.month=3 and ag.year=2024
) ag1
ON a.hierarchy_Id = ag1.treasury  
WHERE 
a.category = 'T'
AND a.hierarchy_Id NOT IN (46609,38123,38119,38137)
ORDER BY 2 desc,1 