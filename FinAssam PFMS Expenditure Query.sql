SELECT m.* FROM 
(
	SELECT SUBSTR(a.financial_year,1,4) finyear1, (CAST(SUBSTR(a.financial_year,1,4) AS INTEGER) + 1) finyear2, 
	'18', substr(dep.hierarchy_Code,1,2) dep_code, 
	replace(substr(h.head,1,20), '-', '') head,  
	replace(substr(h.head,22,26),'-','') obj, st.ddo_code, pb.token_number tsn,
	date(pb.payment_scheduled_on) vd, 
	a.total_allowance, a.total_deduction, a.total_net_amount,
	CONCAT( lpad(t.token,6,'0'), REPLACE( date(t.token_date), '-','' ),try.hierarchy_Code) uid,
	'' ST,'' fn ,'' ud,'' rm,
	emp.beneficiary_bank_account, emp.beneficiary_bank_ifsc, '' city,'' agency,'' ddo_name, (emp.allowance - emp.deduction) ben_net,
	CASE
		WHEN pc.pc_id IS NOT NULL THEN pc.abbreviation
		WHEN h.plan_status = 'NP' THEN 'EE'
		ELSE 'Plan'
	END AS scheme, try.hierarchy_Code tr_code
	#a.* 
	FROM ctmis_master.bill_details_base a 
	JOIN ctmis_master.token_master t
		ON a.token_id = t.id	
	JOIN pfmaster.hierarchy_setup try 
		ON a.treasury_id = try.hierarchy_Id
		AND try.category = 'T'
	JOIN probityfinancials.heads h 
		ON a.head_id = h.head_id
	LEFT JOIN probityfinancials.plan_category_head_mapping pchm 
		ON	h.head_id = pchm.head_id
	LEFT JOIN probityfinancials.plan_category pc 
		ON	pchm.pc_id = pc.pc_id
	LEFT JOIN ctmis_staging.staging_bill_details_base st
		ON a.stager_id = st.id
	JOIN ctmis_master.bill_details_beneficiary emp
		ON a.id = emp.bill_base
	JOIN pfmaster.hierarchy_setup dep
		ON a.department_id = dep.hierarchy_Id
	JOIN ctmis_master.payment_bills pbi
		ON a.id = pbi.bill_details_base_id
	JOIN ctmis_master.payment_base pb
		ON pbi.payment_base_id = pb.id
	WHERE 
	try.hierarchy_Code = 'KAM'
	AND date(pb.payment_scheduled_on) >= '2024-01-29'
) m
WHERE
m.scheme IN 
(
'CS-EE',
'EE-CS',
'EE-SS',
'EE',
'SOPD-ODS',
'PD-SS',
'EAP',
'TG-FFC',
'EAP-SS',
'OPD-SS',
'CSS',
'SOPD-SS',
'SOPD-SCSP SS',
'SOPD-G'
)
AND m.ddo_code like 'FOR/005%'

#LIMIT 0,5
