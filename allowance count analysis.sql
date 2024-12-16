SELECT c.component_name, a.pay_month, 
COUNT(b.bill_beneficiary)
FROM ctmis_master.bill_details_base a
JOIN ctmis_master.bill_details_component b
	ON a.id = b.bill_base
JOIN ctmis_dataset.bill_component_master c
	ON b.component_master = c.code
WHERE
a.pay_year = 2024
AND a.pay_month >= 4
AND a.sub_type = 'SB_SB'
AND a.approved_by IS NOT NULL
AND c.component_type = 'A'
GROUP BY c.component_name, a.pay_month 
ORDER BY 2,3
