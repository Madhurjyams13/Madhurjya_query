SELECT edep.hierarchy_Name, COUNT(eis.id) 
FROM ctmis_master.bill_details_base bd
JOIN ctmis_master.bill_details_beneficiary bdben
	ON bd.id = bdben.bill_base
JOIN ctmis_master.bill_details_component com
	ON bd.id = com.bill_base
	AND bdben.id = com.bill_beneficiary
JOIN probityfinancials.eis_data eis
	ON bdben.beneficiary_id = eis.id
JOIN pfmaster.hierarchy_setup edep
	ON eis.department_id = edep.hierarchy_Id
	AND edep.category = 'D'
WHERE
bd.sub_type = 'SB_SB'
AND bd.approved_by IS NOT NULL
#AND bd.bill_number LIKE '%DISAAT001%'
AND bd.pay_year = 2024
AND bd.pay_month = 4
AND com.component_master = 'SB_SB_TGIS'
AND com.amount = 100 # grade:gis -- 1:400 2:300 3:200 4:100
GROUP BY edep.hierarchy_Name
ORDER BY 1