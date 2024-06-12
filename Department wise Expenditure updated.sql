SELECT m.dep , SUM(amt) FROM 
(

SELECT dep.hierarchy_Name dep, ROUND ( SUM(le.amount)/100000 , 2) amt
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
#JOIN ctmis_master.bill_details_base b
#	ON le.source_reference = b.id 
WHERE
date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND le.source_category = 'BILLS'
GROUP BY dep.hierarchy_Name

UNION ALL


SELECT dep.hierarchy_Name, ROUND ( SUM(le.amount)/100000 , 2) amt
FROM ctmis_accounts.ledger_expenditure le
LEFT JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
LEFT JOIN pfmaster.hierarchy_setup dep
		ON le.department = dep.hierarchy_Id
		AND dep.category = 'D'
#JOIN ctmis_master.bill_details_base b
#	ON le.source_reference = b.id 
WHERE
date(le.expenditure_date) BETWEEN DATE('2023-04-01') AND DATE('2024-03-31')
AND le.financial_year = '2023-24'
AND le.source_category = 'CHEQUE'
GROUP BY dep.hierarchy_Name

) m

GROUP BY m.dep
