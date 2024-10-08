SELECT 
sal.tr, ddo.hierarchy_Code ddo, 
CONCAT(sal.year,'') ,CONCAT(sal.month,''),
sal.sal, up.status, 
nvl(up.nps,0), nvl(up.emp,0), nvl(up.gov,0)
FROM 
(
	SELECT 
	tr.hierarchy_Name tr, a.ddo_id, a.pay_year year, a.pay_month month, 
	SUM(st.incumbent_count) sal
	FROM ctmis_master.bill_details_base a
	JOIN ctmis_staging.staging_bill_details_base st 
		ON a.stager_id = st.id
		AND st.source_bill_type = 'SB'
	JOIN pfmaster.hierarchy_setup tr
		ON a.treasury_id = tr.hierarchy_Id
		AND tr.category = 'T'
	WHERE
	a.sub_type = 'SB_SB'
	AND a.pay_year >= 2024
	AND a.pay_month >= 4
	AND a.approved_by IS NOT NULL
	AND a.bill_pf_type = 'N' 
	GROUP BY tr.hierarchy_Name, a.ddo_id, a.pay_year , a.pay_month
) sal 
LEFT JOIN 
(
	SELECT tr.hierarchy_Name tr, nps.ddo_id, nps.year, nps.month,  
	case 
		when nps.status = 'A' then 'Uploaded'
		when nps.status = 'P' then 'Pending' 
		when nps.status = 'N' then 'No PRAN'
		ELSE 'Other Issue'
	END AS status 
		,
	count(nps.bill_beneficiary_id) nps,
	SUM(nps.employee_contribution) emp, 	
	SUM(nps.employer_contribution) gov
	FROM ctmis_master.bills_nps_deduction nps
	JOIN pfmaster.hierarchy_setup tr
		ON nps.treasury_id = tr.hierarchy_Id
		AND tr.category = 'T'
	WHERE
	nps.year >= 2024
	AND nps.month >= 4
	#AND nps.status = 'A'
	AND nps.type = 'R' 
	GROUP BY tr.hierarchy_Name, nps.ddo_id, nps.year, nps.month,
	case 
		when nps.status = 'A' then 'Uploaded'
		when nps.status = 'P' then 'Pending' 
		when nps.status = 'N' then 'No PRAN'
		ELSE 'Other Issue'
	END
) 
up
	ON sal.tr = up.tr
	AND sal.year = up.year
	AND sal.month = up.month
	AND sal.ddo_id = up.ddo_id
JOIN pfmaster.hierarchy_setup ddo
	ON sal.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
#	WHERE sal.tr='Dispur'
ORDER BY 1,2,3,4,6