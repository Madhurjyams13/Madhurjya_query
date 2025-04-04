SELECT SUBSTR(a.error_description,1,160), 
COUNT(DISTINCT c.id), COUNT(DISTINCT c.employee_id)
FROM ctmis_master.nps_nsdl_fvu_error a
JOIN ctmis_master.bills_nps_contribution_details b
	ON a.bills_nps_contribution_details = b.id
JOIN ctmis_master.bills_nps_deduction c
	ON b.bill_nps_deduction_id = c.id
WHERE
upper(a.error_warning) = 'ERROR' 
AND c.status <> 'A'
GROUP BY SUBSTR(a.error_description,1,160)
LIMIT 10