SELECT mm.pay_month, mm.pay_year, mm.mhead, 
SUM(mm.ben), SUM(mm.total_allowance), SUM(mm.gp + mm.pay), SUM(mm.other)   
FROM 
(
	SELECT m.mhead, m.pay_month, m.pay_year, m.bill_number,  m.total_allowance, m.ben, 
	SUM( case when m.component_master = 'SB_SB_GP' then m.amount END) AS gp, 
	SUM( case when m.component_master = 'SB_SB_PAY' then m.amount END) AS pay,
	SUM( case when m.component_master NOT IN ('SB_SB_PAY','SB_SB_GP') then m.amount END) AS other
	FROM 
	(
		SELECT CONCAT( mh.head_code, '->', mh.head_name) mhead,
		bd.pay_month, bd.pay_year, bd.bill_number, c.component_master, bd.total_allowance, c.amount, d.component_name,
		COUNT(b.id) ben 
		FROM ctmis_accounts.ledger_expenditure le
		JOIN ctmis_master.bill_details_base bd 
			ON le.source_reference = bd.id
		JOIN probityfinancials.heads h 
			ON le.head_of_account = h.head_id 
		JOIN probityfinancials.head_setup dh 
			ON h.detailed_head = dh.head_setup_id
		JOIN ctmis_master.bill_details_beneficiary b 
			ON le.source_reference = b.bill_base
		LEFT JOIN ctmis_master.bill_details_component c 
			ON bd.id=c.bill_base
		JOIN ctmis_dataset.bill_component_master d
			on c.component_master= d.code 
			and d.component_type='A'
		JOIN probityfinancials.head_setup mh 
			ON h.major_head = mh.head_setup_id 
		WHERE  
		date(bd.voucher_date) BETWEEN '2024-01-01' AND '2024-03-31'
		AND le.source_category = 'BILLS'
		AND dh.head_code = '01'
		AND bd.sub_type = 'SB_SB'
		#AND bd.bill_number LIKE 'BILL/202324/DISAAT001%'
		AND bd.pay_month IN (1,2)
		AND bd.pay_year = 2024
		GROUP BY bd.pay_month, bd.pay_year, bd.bill_number, c.component_master, 
		bd.total_allowance, c.amount, d.component_name,
		CONCAT( mh.head_code, '->', mh.head_name)
	) m 
	GROUP BY m.mhead, m.pay_month, m.pay_year, m.bill_number, m.total_allowance, m.ben 
) mm
GROUP BY mm.pay_month, mm.pay_year, mm.mhead
ORDER BY 1,3