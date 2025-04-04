SELECT 
a.eis_id, a.id,
case 
	when a.signed_csrf IS NULL
		then 'Signed CSRF Not submitted'
	when a.signed_csrf IS NOT NULL AND  b.pran_no IS NULL 
		then 'PRAN Not Mapped in EIS Data'
	when NOT EXISTS 
		(
			SELECT z.* 
			FROM ctmis_master.bills_nps_deduction z
			WHERE 
			a.pran_no = z.pran			
		)	
	then 'PRAN Not Mapped in Upload Tables'
	when NOT EXISTS 
		(
			SELECT z.* 
			FROM ctmis_master.bills_nps_deduction z
			WHERE 
			a.pran_no = z.pran
			AND z.status = 'A'			
		)	
	then 'PRAN Mapped but Not Uploaded'
	when EXISTS 
		(
			SELECT z.* 
			FROM ctmis_master.bills_nps_deduction z
			WHERE 
			a.pran_no = z.pran
			AND z.status = 'A'			
		)	
	then 'PRAN Mapped - Uploaded'
END AS STATUS ,
a.ppan_no, a.pran_no, 
date(a.submitted_nsdl_on), a.pran_issued_on,
a.signed_csrf, b.pran_no, b.gpf_or_ppan_no,
tr.hierarchy_Name, tr.hierarchy_Code, ddo.hierarchy_Code,
b.emp_First_Name, b.emp_middle_Name, b.emp_Last_Name
#,a.*
FROM probityfinancials.nps_base a
JOIN probityfinancials.eis_data b
	ON a.eis_id = b.id
JOIN pfmaster.hierarchy_setup ddo
	ON b.ddo_Id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN pfmaster.hierarchy_setup tr
	ON b.treasury_Id = tr.hierarchy_Id
	AND tr.category = 'T'
WHERE
DATE(a.pran_issued_on) BETWEEN '2024-07-01' AND '2025-01-18'
AND a.pran_status = 'A' 
ORDER BY 5 DESC  
#LIMIT 100