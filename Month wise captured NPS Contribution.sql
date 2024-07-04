SELECT concat(tr.hierarchy_Code,' - ',tr.hierarchy_Name),
a.month,
#COUNT(*), SUM(a.employee_contribution), 
SUM(a.employer_contribution)
from ctmis_master.bills_nps_deduction a
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
WHERE
a.year = 2024
AND a.month < 6
AND a.`type` = 'R'
GROUP BY 
concat(tr.hierarchy_Code,' - ',tr.hierarchy_Name),
a.month
ORDER BY 1,2