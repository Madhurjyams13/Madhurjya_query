SELECT emp.* FROM 
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
	tr.hierarchy_Name
	#,a.*	 
	FROM probityfinancials.eis_data a
	LEFT JOIN probityfinancials.nps_base b
		ON a.id = b.eis_id
	JOIN pfmaster.hierarchy_setup ddo
		ON a.ddo_Id = ddo.hierarchy_Id
		AND ddo.category = 'S'
	JOIN pfmaster.hierarchy_setup tr
		ON substr(ddo.hierarchy_Code,1,INSTR(ddo.hierarchy_Code,'/')-1) 
		= tr.hierarchy_Code
		AND tr.category = 'T'
	WHERE
	a.gpf_or_ppan_no = '2006282700100493'
) emp
