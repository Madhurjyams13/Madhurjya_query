SELECT 
dep.hierarchy_Name,
ROUND ( SUM(le.amount)/10000000 ,2) 
FROM ctmis_accounts.ledger_expenditure le 
LEFT JOIN pfmaster.hierarchy_setup dep 
	ON le.department = dep.hierarchy_Id
	AND dep.category = 'D'
WHERE
date(le.expenditure_date) BETWEEN DATE('2024-04-01') AND DATE('2024-04-17')
AND le.source_category = 'BILLS'
GROUP BY dep.hierarchy_Name