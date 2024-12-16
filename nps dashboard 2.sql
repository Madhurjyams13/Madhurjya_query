SELECT m.* FROM 
(		
		SELECT
		DISTINCT 
		tr.hierarchy_Code tr_code,
		tr.hierarchy_Name tr_name,
		ddo.hierarchy_Code ddo,
		a.year,
		a.month,
		a.ppan,
		a.pran,
		case 
			when a.status = 'A'
				then 'Uploaded'
			when a.status = 'N' 
				then 'No PRAN'
			when a.status = 'I' 
				then 'Confirmation Awaiting'	
			ELSE 'Others'
		END AS upload_status,
		b.status, 
		'',
		case 
			when a.status = 'A'
				then DATEDIFF(b.entry_date,a.entry_date) 
			else
				DATEDIFF(NOW(),a.entry_date)  
		END AS delay, a.id
		FROM ctmis_master.bills_nps_deduction a
		LEFT JOIN ctmis_master.bills_nps_contribution_details b
			ON a.id = b.bill_nps_deduction_id
		JOIN pfmaster.hierarchy_setup tr
			ON a.treasury_id = tr.hierarchy_Id
			AND tr.category = 'T'
		JOIN pfmaster.hierarchy_setup ddo
			ON a.ddo_id = ddo.hierarchy_Id
			AND ddo.category = 'S'
		WHERE
		CONCAT(a.year, LPAD(a.month, 2, '0')) >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 MONTH), '%Y%m')
		AND a.status IN ('A','N','I')
		AND a.type = 'R'
		
UNION ALL

		SELECT
		DISTINCT 
		tr.hierarchy_Code tr_code,
		tr.hierarchy_Name tr_name,
		ddo.hierarchy_Code ddo,
		a.year,
		a.month,
		a.ppan,
		a.pran,
		case 
			when b.bill_nps_deduction_id IS NULL 
				then 'Not Attempted'
			when EXISTS 
				(
					SELECT 1 FROM 
					ctmis_master.bills_nps_contribution_details n
					WHERE 
					a.id = n.bill_nps_deduction_id
					AND n.status = 'Rejected' 
				)
				then 'Error in Upload'
			ELSE 'Others'
		END AS upload_status,
		b.status, 
		e.error_description,
		case 
			when a.status = 'A'
				then DATEDIFF(b.entry_date,a.entry_date) 
			else
				DATEDIFF(NOW(),a.entry_date)  
		END AS delay, a.id
		FROM ctmis_master.bills_nps_deduction a
		LEFT JOIN ctmis_master.bills_nps_contribution_details b
			ON a.id = b.bill_nps_deduction_id
		LEFT JOIN ctmis_master.nps_nsdl_fvu_error e
			ON b.id = e.bills_nps_contribution_details
		JOIN pfmaster.hierarchy_setup tr
			ON a.treasury_id = tr.hierarchy_Id
			AND tr.category = 'T'
		JOIN pfmaster.hierarchy_setup ddo
			ON a.ddo_id = ddo.hierarchy_Id
			AND ddo.category = 'S'
		WHERE
		CONCAT(a.year, LPAD(a.month, 2, '0')) >= DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 MONTH), '%Y%m')
		AND a.status IN ('P')
		AND a.type = 'R'
)	m
#WHERE
#m.upload_status = 'Error in Upload'