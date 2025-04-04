SET @myppan = '1993232700200202';

SELECT @myppan, YEAR(c.submitted_nsdl_on), 
lpad(MONTH(c.submitted_nsdl_on),2,0), 
date(c.submitted_nsdl_on),
a.ppan, a.pran, a.year,
LPAD(a.month,2,0),
a.employee_contribution,
case
	when a.type = 'R'
		then 'Regular'
	when a.type = 'A'
		then 'Arrear'
END AS ctype, 
case 
	when c.transaction_id IS NULL 
		then a.TRANS_ID
	ELSE c.transaction_id
END AS trans_id,
'Uploaded',
a.employer_contribution
FROM ctmis_master.bills_nps_deduction a
JOIN ctmis_master.bills_nps_contribution_details b
	ON a.id = b.bill_nps_deduction_id
JOIN ctmis_master.bills_nps_contribution_base c
	ON b.bill_nps_contribution_base_id = c.id
WHERE
a.ppan =  @myppan
AND a.status = 'A'

UNION ALL

SELECT 
@myppan,
'','', '', a.ppan, a.pran, a.year, LPAD(a.month,2,0),
a.employee_contribution,
case
	when a.type = 'R'
		then 'Regular'
	when a.type = 'A'
		then 'Arrear'
END AS ctype, 
'', 
case 
	when a.status = 'P'
		then 'Pending'
	when a.status = 'N'
		then 'No PRAN'
	ELSE 
		'Others'
END AS cstatus,
a.employer_contribution	 
FROM ctmis_master.bills_nps_deduction a
WHERE
a.ppan = @myppan
AND a.status <> 'A'

ORDER BY 6,7