SELECT c.pay_year, c.pay_month,
SUM(b.allowance), SUM(b.deduction),
COUNT(a.id)
FROM ctmis_master.bill_details_base c
JOIN ctmis_master.bill_details_beneficiary b
	ON c.id = b.bill_base
JOIN probityfinancials.eis_data a
	ON b.beneficiary_id = a.id
WHERE
c.pay_year = 2024
AND c.approved_by IS NOT NULL
AND date(c.token_date) >= '2024-01-01' 
AND (a.id, c.pay_year, c.pay_month)
IN 
(
	SELECT a.id,
	MAX(c.pay_year), MAX(c.pay_month)
	FROM probityfinancials.eis_data a 
	JOIN ctmis_master.bill_details_beneficiary b
		ON a.id = b.beneficiary_id
	JOIN ctmis_master.bill_details_base c
		ON b.bill_base = c.id
	JOIN pfmaster.hierarchy_setup d
		ON a.ddo_Id = d.hierarchy_Id
	WHERE
	a.removed_by_ddo = 'Y'
	AND a.removal_reason = 'R' 
	AND c.pay_year = 2024
	AND c.sub_type = 'SB_SB'
	AND c.approved_by IS NOT NULL
	GROUP BY a.id
)
GROUP BY c.pay_year, c.pay_month
ORDER BY 2