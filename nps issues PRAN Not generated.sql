## PRAN NOT GENERATED
SELECT eis.id, 
ddo.hierarchy_Code ddo_code, ofc.office_Name ofc_name, 
try.hierarchy_Code try_code, try.hierarchy_Name try_name,
a.request_number proposal_no,
eis.appoin_Date,
date(a.submitted_treasury_on) ppan_submission,
DATEDIFF(NOW(), date(a.submitted_treasury_on)) delay_day,
a.ppan_no nps_ppan, a.pran_no nps_pran,
eis.gpf_or_ppan_no eis_ppan, eis.pran_no eis_pran,
a.ppan_status,
case
	when a.ppan_status = 'S'
		then 'Submitted'
	when a.ppan_status = 'R'
		then 'Rejected'
	when a.ppan_status = 'A'
		then 'Approved'
	ELSE 'Not Available'
	END AS ppan_status,
trim(concat(eis.emp_First_Name, ' ', ifnull(eis.emp_middle_Name,''), ' ', eis.emp_Last_Name)) name,
eis.acc_Num, eis.removed_by_ddo, eis.removal_reason, eis.removal_remarks,
eis.removed_on, a.pran_updated_from_blob
#,a.*
FROM probityfinancials.nps_base a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
JOIN pfmaster.hierarchy_setup ofc
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
JOIN probityfinancials.eis_data eis
	ON a.eis_id = eis.id
JOIN pfmaster.hierarchy_setup try
	ON eis.treasury_Id = try.hierarchy_Id
WHERE
a.submitted_treasury_by IS NOT NULL
AND a.ppan_no IS NOT NULL 
AND a.pran_no IS NULL 
AND eis.removed_by_ddo = 'N'
ORDER BY 7 DESC 
#LIMIT 0,10