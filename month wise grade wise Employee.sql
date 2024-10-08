SELECT bd.pay_month ,com.amount, COUNT(eis.id) 
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
AND bd.pay_month IN (4,5,6,7)
AND com.component_master = 'SB_SB_TGIS'
AND com.amount IN (100,200,300,400) # grade:gis -- 1:400 2:300 3:200 4:100
GROUP BY bd.pay_month ,com.amount
ORDER BY 1,2