SELECT replace(trim(a.beneficiary_name),'  ',' '), p.post_Name, 
o.bill_number, o.bill_date, 
o.pay_year, o.pay_month, date(o.voucher_date),
p.post_Name, a.allowance, a.deduction, d.amount hra, f.amount pay, 
g.amount gp 
FROM ctmis_master.bill_details_beneficiary a
JOIN probityfinancials.eis_data e
	ON a.beneficiary_id = e.id
JOIN probityfinancials.post_setup p
	ON e.post_Id = p.post_Id 
JOIN ctmis_master.bill_details_component d
	ON a.id = d.bill_beneficiary
	AND a.bill_base = d.bill_base
	AND d.component_master = 'SB_SB_HR'
LEFT JOIN ctmis_master.bill_details_component f
	ON a.id = f.bill_beneficiary
	AND a.bill_base = f.bill_base
	AND f.component_master = 'SB_SB_PAY'	
LEFT JOIN ctmis_master.bill_details_component g
	ON a.id = g.bill_beneficiary
	AND a.bill_base = g.bill_base
	AND g.component_master = 'SB_SB_GP'	
LEFT JOIN ctmis_master.bill_details_base o
	ON a.bill_base = o.id
WHERE
EXISTS 
(
	SELECT c.* 
	FROM ctmis_master.bill_details_component c 
	WHERE 
	a.id = c.bill_beneficiary
	AND c.component_master = 'SB_SB_AISS'
)
AND date(o.voucher_date) >= '2024-04-01'
#AND a.beneficiary_id = 1049578
AND a.beneficiary_type = 'E'
ORDER BY e.id
