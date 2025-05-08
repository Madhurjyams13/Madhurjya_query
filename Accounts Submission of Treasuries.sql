SELECT #tr.hierarchy_Id, 
tr.hierarchy_Code "Treasury Code", tr.hierarchy_Name "Treasury Name",
ag.year "Year", ag.month "Month",
date(ag.submitted_on) "Submission Date", 
case 
	when ag.treasury IS NULL 
		then 'NOT Initiated'
	when ag.data_status = 'N'
		then 'NOT Submitted'
	when ag.data_status = 'Y'
		then 'Submitted to AG'
END AS "Status"
FROM pfmaster.hierarchy_setup tr
LEFT JOIN ag_submission.ag_submission_details ag
	ON tr.hierarchy_Id = ag.treasury
	AND ag.year = YEAR(CURRENT_DATE - INTERVAL 1 MONTH)
	AND ag.month = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
WHERE
tr.category = 'T'
AND tr.hierarchy_Id NOT IN (38119,38123,38137,46609)
ORDER BY 4, 5 DESC  