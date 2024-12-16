SELECT com.*, bill.* FROM 
(
	SELECT dm.dep_id, dm.dname, cm.code, cm.cname FROM 
	(
		SELECT 'join', d.code, d.component_name cname
		FROM ctmis_dataset.bill_component_master d
		WHERE 
		d.bill_sub_type = 'SB_SB'
		AND d.component_type = 'A'
	) cm
	JOIN 
	(
		SELECT 'join', dep1.hierarchy_id dep_id,
		dep1.hierarchy_Name dname
		FROM pfmaster.hierarchy_setup dep1
		WHERE
		dep1.category = 'D'
	) dm
	ON cm.join = dm.join 
) com
LEFT JOIN  
(
	SELECT DISTINCT b.department_id dep_id, c.component_master code
	FROM ctmis_master.bill_details_base b
	JOIN ctmis_master.bill_details_component c
		ON c.bill_base = b.id
	WHERE
	b.sub_type = 'SB_SB'
	AND b.pay_year >= 2024
	AND b.voucher_date IS NOT NULL 
) bill
ON com.dep_id = bill.dep_id
AND com.code = bill.code
WHERE
bill.dep_id IS NULL 