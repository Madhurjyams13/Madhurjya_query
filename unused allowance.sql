SELECT cm.code, cm.cname FROM 
	(
		SELECT d.code, d.component_name cname
		FROM ctmis_dataset.bill_component_master d
		WHERE 
		d.bill_sub_type = 'SB_SB'
		AND d.component_type = 'A'
	) cm
LEFT JOIN  
(
	SELECT DISTINCT c.component_master code
	FROM ctmis_master.bill_details_base b
	JOIN ctmis_master.bill_details_component c
		ON c.bill_base = b.id
	WHERE
	b.sub_type = 'SB_SB'
	AND b.pay_year >= 2024
	AND b.voucher_date IS NOT NULL 
) bill
ON cm.code = bill.code
WHERE
bill.code IS NULL 
