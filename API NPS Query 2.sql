SELECT emp.*, 
concat(YEAR(con.first_capture),'/',lpad(MONTH(con.first_capture),2,0)), 
concat(YEAR(con.last_capture),'/',lpad(MONTH(con.last_capture),2,0)),
con.total_capture,
concat(YEAR(con.first_upload),'/',lpad(MONTH(con.first_upload),2,0)),
concat(YEAR(con.last_upload),'/',lpad(MONTH(con.last_upload),2,0)),
con.total_upload from 
(
	SELECT 
	a.gpf_or_ppan_no ppan,
	case 
		when a.removed_by_ddo = 'Y' AND a.removal_reason = 'T' then 'Transfer'
		when a.removed_by_ddo = 'Y' AND a.removal_reason = 'R' then 'Retired'
		when a.removed_by_ddo = 'Y' AND a.removal_reason = 'E' then 'Expired'
		when a.removed_by_ddo = 'Y' AND a.removal_reason = 'S' then 'Resigned'
		when a.removed_by_ddo = 'Y' AND a.removal_reason = 'O' then 'Duplicate/ Invalid Details'
		when a.removed_by_ddo = 'Y' AND a.removal_reason = 'SP' then 'Suspended'
		when a.removed_by_ddo = 'N' then 'Active'
		ELSE 'Other'
	END AS status, a.pran_no, b.pran_issued_on,
	a.dateofbirth, a.emp_retirement_date,
	CONCAT(
		UPPER(a.emp_First_Name),' ', 
		IFNULL(a.emp_middle_Name,''), ' ', 
		upper(a.emp_Last_Name)
		) name,
		substr(ddo.hierarchy_Code,1,INSTR(ddo.hierarchy_Code,'/')-1) try,
		SUBSTR(ddo.hierarchy_Code,INSTR(ddo.hierarchy_Code,'/')+1, LENGTH(ddo.hierarchy_Code)) ddo,
		tr.dto_reg_no, tr.ddo_reg_no,
	tr.treasury_name
	#,a.*	 
	FROM probityfinancials.eis_data a
	LEFT JOIN probityfinancials.nps_base b
		ON a.id = b.eis_id
	JOIN pfmaster.hierarchy_setup ddo
		ON a.ddo_Id = ddo.hierarchy_Id
		AND ddo.category = 'S'
	JOIN probityfinancials.treasury_setup tr
		ON a.treasury_Id = tr.treasury_hierarchy
	WHERE
	a.gpf_or_ppan_no = '2004182000102959'
) emp

LEFT JOIN 
(
	SELECT cap.ppan, 
	cap.first_capture, cap.last_capture, cap.total_capture,
	up.first_upload, up.last_upload, up.total_upload
	FROM 
	(
	SELECT m.ppan, 
	COUNT(m.pmonth) total_capture, MIN(m.pmonth) first_capture,  
	MAX(m.pmonth) last_capture
	FROM 
	(
		SELECT 
		STR_TO_DATE(
			CONCAT(
				CAST(b.year AS CHAR), 
				'-', 
				LPAD(CAST(b.month AS CHAR), 2, '0'), 
				'-01'
				)
		, '%Y-%m-%d') pmonth, b.*
		FROM ctmis_master.bills_nps_deduction b
		WHERE
		b.ppan = '2004182000102959' 
	) m
	GROUP BY m.ppan
	) cap 
	
	LEFT JOIN 
	(
	SELECT m.ppan, 
	COUNT(m.pmonth) total_upload, MIN(m.pmonth) first_upload,  
	MAX(m.pmonth) last_upload
	FROM 
	(
		SELECT 
		STR_TO_DATE(
			CONCAT(
				CAST(b.year AS CHAR), 
				'-', 
				LPAD(CAST(b.month AS CHAR), 2, '0'), 
				'-01'
				)
		, '%Y-%m-%d') pmonth, b.*
		FROM ctmis_master.bills_nps_deduction b
		WHERE
		b.ppan = '2004182000102959'
		AND b.status = 'A'
	) m
	GROUP BY m.ppan
	) up 
	ON cap.ppan = up.ppan
) con
ON emp.ppan = con.ppan