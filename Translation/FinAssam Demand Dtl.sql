SELECT t.token, try.hierarchy_Code, DATE(t.token_date), 
substr(dep.hierarchy_Code,1,2) DEP_CODE, IFNULL(a.demand_number,0) DEMAND_NUMBER , 
'' CREATE_UID, DATE(t.token_date) CREATE_DATE, '' MODIFIED_UID, '' MODIFIED_DATE
,'----', st.ddo_code, a.bill_number
,'-----', a.* 
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id	
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T'
LEFT JOIN ctmis_staging.staging_bill_details_base st
	ON a.stager_id = st.id
JOIN pfmaster.hierarchy_setup dep
	ON a.department_id = dep.hierarchy_Id
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28' 
AND a.demand_number IS NULL 
ORDER BY a.id DESC 
#LIMIT 0,50 