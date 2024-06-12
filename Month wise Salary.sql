SELECT m.pay_year, m.pay_month, 
SUM(m.ben), ROUND(SUM(m.total_allowance)/10000000,2), ROUND(SUM(m.total_net_amount)/10000000,2) 
FROM 
(
	SELECT bd.id, bd.bill_number, bd.pay_year, bd.pay_month, bd.total_allowance, bd.total_net_amount,
	COUNT(b.id) ben
	FROM ctmis_accounts.ledger_expenditure le
	JOIN ctmis_master.bill_details_base bd 
		ON le.source_reference = bd.id
		AND le.source_category = 'BILLS'
	JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
	JOIN probityfinancials.head_setup dh 
		ON h.detailed_head = dh.head_setup_id
	JOIN ctmis_master.bill_details_beneficiary b 
		ON bd.id=b.bill_base
	WHERE
	date(bd.voucher_date) BETWEEN '2023-04-01' AND '2024-05-06' 
	AND le.financial_year IN ( '2023-24' , '2024-25')
	AND le.source_category = 'BILLS'
	AND dh.head_code = '02'
	AND bd.sub_type = 'WB_WB'
	
	GROUP BY bd.id, bd.bill_number, bd.pay_year, bd.pay_month, bd.total_allowance, bd.total_net_amount
) m

GROUP BY m.pay_year, m.pay_month

ORDER BY 1,2
	