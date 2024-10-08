SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS dep,
dir.hierarchy_Name dir, 
ddo.hierarchy_Code ,
#,bbb.mmonth, 
COUNT(a.id)
FROM probityfinancials.eis_data a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_Id = ddo.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep
	ON ddo.parent_hierarchy = dep.hierarchy_Id
JOIN pfmaster.hierarchy_setup dir
	ON dep.parent_hierarchy = dir.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep1
	ON dir.parent_hierarchy = dep1.hierarchy_Id
LEFT JOIN 
(
	SELECT bb.beneficiary_id, 
	MAX(
	case 
		when CONCAT('01-',lpad(cc.pay_month,2,'0'),'-',cc.pay_year) IS NOT NULL 
		then DATE_FORMAT(
			str_to_date(CONCAT('01-',lpad(cc.pay_month,2,'0'),'-',cc.pay_year),'%d-%m-%Y'),
			'%Y/%m'
			)
		ELSE date_format(STR_TO_DATE('01-01-1990','%d-%m-%Y'),'%Y/%m')
		END ) mmonth
	FROM ctmis_master.bill_details_beneficiary bb
	JOIN ctmis_master.bill_details_base cc
		ON bb.bill_base = cc.id
	WHERE
	cc.approved_by IS NOT NULL
	AND cc.sub_type = 'SB_SB'
	GROUP BY bb.beneficiary_id 
	#LIMIT 0,10
) bbb 
	ON a.id = bbb.beneficiary_id
WHERE
a.removed_by_ddo = 'N'
AND ddo.hierarchy_Code NOT LIKE 'XXX%'
AND a.ddo_Id IS NOT NULL
AND NOT EXISTS 
(
	SELECT b.* 
	FROM ctmis_master.bill_details_beneficiary b
	JOIN ctmis_master.bill_details_base c
		ON b.bill_base = c.id
		AND c.pay_month = 4
		AND c.pay_year = 2024
		AND c.sub_type = 'SB_SB'
	WHERE
	a.id = b.beneficiary_id
)
group by case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END ,
dir.hierarchy_Name, 
ddo.hierarchy_Code
#,bbb.mmonth
ORDER BY 1,2,3