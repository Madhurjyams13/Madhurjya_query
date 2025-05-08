SELECT m.* FROM 
(
	
	SELECT 'Orunodoi EPR', 
	DATE_FORMAT(
		DATE_SUB(
			a.received_on, INTERVAL MINUTE(a.received_on) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	) AS time_frame,
	round(sum(round(a.total_allowance/1250))/100) ins
	FROM ctmis_master.bill_details_base a
	WHERE
	a.head_id = 111156
	AND date(a.received_on) >= DATE(NOW()) 
	GROUP BY DATE_FORMAT(
		DATE_SUB(
			a.received_on, INTERVAL MINUTE(a.received_on) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	)
	#DATE(a.received_on) = '2025-04-07'
	UNION ALL 
	
	SELECT 'Salary EPR Component', 
	DATE_FORMAT(
		DATE_SUB(
			a.received_on, INTERVAL MINUTE(a.received_on) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	) AS grouped_time,
	ROUND(COUNT(c.id)/100)
	FROM ctmis_master.bill_details_base a
	JOIN ctmis_master.bill_details_component c
		ON a.id = c.bill_base
	WHERE
	DATE(a.received_on) >= DATE(NOW())
	AND a.sub_type = 'SB_SB'
	GROUP BY DATE_FORMAT(
		DATE_SUB(
			a.received_on, INTERVAL MINUTE(a.received_on) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	)
	#DATE(a.received_on) = '2025-04-07'
	
	
	UNION ALL 
	
	SELECT 'Salary EPR Beneficiary', 
	DATE_FORMAT(
		DATE_SUB(
			a.received_on, INTERVAL MINUTE(a.received_on) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	) AS grouped_time,
	ROUND(COUNT(d.id)/100)
	FROM ctmis_master.bill_details_base a
	JOIN ctmis_master.bill_details_beneficiary d
		ON a.id = d.bill_base
	WHERE
	DATE(a.received_on) >= DATE(NOW())
	AND a.sub_type = 'SB_SB'
	GROUP BY DATE_FORMAT(
		DATE_SUB(
			a.received_on, INTERVAL MINUTE(a.received_on) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	)
	#DATE(a.received_on) = '2025-04-07'
	
	UNION ALL 
	
	SELECT
	'Orunodoi Source',
	DATE_FORMAT(
		DATE_SUB(
			b.entry_date, INTERVAL MINUTE(b.entry_date) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	), round(COUNT(b.detail_id)/100)
	FROM pfpaybills.paybill_base a
	JOIN pfpaybills.paybill_gia_details b
		ON a.bill_id = b.base_id
	WHERE
	a.head_id = 111156
	AND DATE(b.entry_date) >= DATE(NOW())
	GROUP BY DATE_FORMAT(
		DATE_SUB(
			b.entry_date, INTERVAL MINUTE(b.entry_date) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	)
	
	UNION ALL 
	
	SELECT 'Salary Source Deduction',
	DATE_FORMAT(
		DATE_SUB(
			b.entry_date, INTERVAL MINUTE(b.entry_date) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	) AS grouped_time,
	round(COUNT(b.deduction_id)/100)
	FROM pfpaybills.salary_deductions b
	WHERE
	date(b.entry_date) >= DATE(NOW())
	GROUP BY DATE_FORMAT(
		DATE_SUB(
			b.entry_date, INTERVAL MINUTE(b.entry_date) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	)
	
	
	UNION ALL 
	
	
	SELECT 'Salary Source Allowance',
	DATE_FORMAT(
		DATE_SUB(
			b.entry_date, INTERVAL MINUTE(b.entry_date) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	) AS grouped_time,
	round(COUNT(b.allowance_id)/100)
	FROM pfpaybills.salary_allowances b
	WHERE
	date(b.entry_date) >= DATE(NOW())
	GROUP BY DATE_FORMAT(
		DATE_SUB(
			b.entry_date, INTERVAL MINUTE(b.entry_date) % 15 MINUTE), 
			'%Y-%m-%d %H:%i'	
	)

) m
