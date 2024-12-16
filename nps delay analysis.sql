SELECT #n.tr, 
n.month, n.delay_status, COUNT(n.id) FROM 
(
	SELECT m.*,  
	case
		when m.delay < 2
			then 'Within 1 Day'
		when m.delay >= 2 AND m.delay < 5
			then 'Within 2 to 4 Days'
		when m.delay >= 5 AND m.delay < 7
			then 'Within 4 to 6 Days'
		when m.delay >= 7
			then 'in More than 7 Days'
	END AS delay_status
	FROM
	(
		SELECT 
		tr.hierarchy_Name tr,
		a.month,
		case 
			when a.status = 'A'
				then DATEDIFF(b.entry_date,a.entry_date) 
			else
				DATEDIFF(NOW(),a.entry_date)  
		END AS delay, a.id
		FROM ctmis_master.bills_nps_deduction a
		LEFT JOIN ctmis_master.bills_nps_contribution_details b
			ON a.id = b.bill_nps_deduction_id
		LEFT JOIN pfmaster.hierarchy_setup tr
			ON a.treasury_id = tr.hierarchy_Id
			AND tr.category = 'T'
		WHERE
		a.year >= 2024
		AND a.month >= 8
		AND a.status IN ('A','P') 
		AND a.type = 'R'
		ORDER BY a.entry_date DESC 
	)
	m
)
n
GROUP BY #n.tr, 
n.month, n.delay_status
ORDER BY 1,2,3
;
#LIMIT 0,10

SELECT n.tr, 
n.month, n.delay_status, COUNT(n.id) FROM 
(
	SELECT m.*,  
	case
		when m.delay < 2
			then 'Within 1 Day'
		when m.delay >= 2 AND m.delay < 5
			then 'Within 2 to 4 Days'
		when m.delay >= 5 AND m.delay < 7
			then 'Within 4 to 6 Days'
		when m.delay >= 7
			then 'in More than 7 Days'
	END AS delay_status
	FROM
	(
		SELECT 
		tr.hierarchy_Name tr,
		a.month,
		case 
			when a.status = 'A'
				then DATEDIFF(b.entry_date,a.entry_date) 
			else
				DATEDIFF(NOW(),a.entry_date)  
		END AS delay, a.id
		FROM ctmis_master.bills_nps_deduction a
		LEFT JOIN ctmis_master.bills_nps_contribution_details b
			ON a.id = b.bill_nps_deduction_id
		LEFT JOIN pfmaster.hierarchy_setup tr
			ON a.treasury_id = tr.hierarchy_Id
			AND tr.category = 'T'
		WHERE
		a.year >= 2024
		AND a.month >= 8
		AND a.status IN ('A','P') 
		AND a.type = 'R'
		ORDER BY a.entry_date DESC 
	)
	m
)
n
GROUP BY n.tr, 
n.month, n.delay_status
ORDER BY 1,2,3
;
