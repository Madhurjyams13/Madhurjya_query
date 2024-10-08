SELECT 
CONCAT(eis.emp_First_Name, ' ', IFNULL(eis.emp_middle_Name,''), ' ', eis.emp_Last_Name) name,
nps.ppan_no nps_ppan, nps.pran_no nps_pran,
eis.gpf_or_ppan_no eis_ppan, eis.pran_no eis_pran,
npsd.ppan npsd_ppan, npsd.pran npsd_pran, 
ddo.hierarchy_Code, ofc.office_Name,
try.hierarchy_Name, 
eis.removed_on,
eis.removed_by_ddo, eis.removal_reason, eis.removal_remarks,
date(nps.submitted_treasury_on) ppan_submission, nps.ppan_issued_on, 
date(nps.submitted_nsdl_on), nps.pran_issued_on,
SUM(case when npsd.status IN ('P','N') then 1 ELSE 0 END) pending_count,
SUM(case when npsd.status IN ('P','N') then npsd.employee_contribution ELSE 0 END) pending_emp ,
SUM(case when npsd.status IN ('P','N') then npsd.employer_contribution ELSE 0 END) pending_gov,
SUM(case when npsd.status IN ('A') then 1 ELSE 0 END) upload_count,
SUM(case when npsd.status IN ('A') then npsd.employee_contribution ELSE 0 END) upload_emp ,
SUM(case when npsd.status IN ('A') then npsd.employer_contribution ELSE 0 END) upload_gov
#SUM(case when npsd.status IN ('A') then 1 ELSE 0 END) upload_count,
#COUNT(*), SUM(npsd.employee_contribution), SUM(npsd.employer_contribution)
#,eis.*
FROM probityfinancials.eis_data eis
JOIN pfmaster.hierarchy_setup ddo
	ON eis.ddo_id = ddo.hierarchy_Id
JOIN pfmaster.hierarchy_setup ofc
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
JOIN pfmaster.hierarchy_setup try
	ON eis.treasury_Id = try.hierarchy_Id
LEFT JOIN probityfinancials.nps_base nps
	ON eis.id = nps.eis_id
LEFT JOIN ctmis_master.bills_nps_deduction npsd
	ON eis.gpf_or_ppan_no = npsd.ppan
WHERE
DATE(eis.appoin_Date) = '2024-03-01'
AND eis.post_Id = 190
AND eis.gpf_or_ppan_no IN ('2024415000700023')
GROUP BY
CONCAT(eis.emp_First_Name, ' ', IFNULL(eis.emp_middle_Name,''), ' ', eis.emp_Last_Name),
nps.ppan_no , nps.pran_no ,
eis.gpf_or_ppan_no , eis.pran_no ,
npsd.ppan , npsd.pran , 
ddo.hierarchy_Code, ofc.office_Name,
try.hierarchy_Name, 
eis.removed_on,
eis.removed_by_ddo, eis.removal_reason, eis.removal_remarks,
date(nps.submitted_treasury_on) , nps.ppan_issued_on, 
date(nps.submitted_nsdl_on), nps.pran_issued_on
ORDER BY 2
