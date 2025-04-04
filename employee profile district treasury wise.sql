SELECT a.emp_title_name, a.emp_First_Name, a.emp_middle_Name, 
a.emp_Last_Name, a.acc_Num, a.mobile_no,
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS dep,
dir.hierarchy_Name dir, dm.district_Name,
tr.hierarchy_Name,
ddo.hierarchy_Code, 
ddon.office_Name,
a.gpf_or_ppan_no, a.emp_no
FROM probityfinancials.eis_data a
LEFT JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_Id = ddo.hierarchy_Id
LEFT JOIN pfmaster.hierarchy_setup ddon
	ON ddo.parent_hierarchy = ddon.hierarchy_Id
LEFT JOIN pfmaster.hierarchy_setup dep
	ON ddo.parent_hierarchy = dep.hierarchy_Id
LEFT JOIN pfmaster.hierarchy_setup dir
	ON dep.parent_hierarchy = dir.hierarchy_Id
LEFT JOIN pfmaster.hierarchy_setup dep1
	ON dir.parent_hierarchy = dep1.hierarchy_Id
LEFT JOIN probityfinancials.ddo_setup dis
	ON a.ddo_id = dis.ddo_id
LEFT JOIN probityfinancials.district_setup dm
	ON dis.district_id = dm.district_Id
LEFT JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_Id = tr.hierarchy_Id
	AND tr.category = 'T'
WHERE
EXISTS
(
	SELECT z.* 
	FROM ctmis_master.bill_details_beneficiary z
	JOIN ctmis_master.bill_details_base y
		ON z.bill_base = y.id
	WHERE
	y.pay_year = 2024
	AND y.pay_month IN (10,11,12)
	AND y.sub_type = 'SB_SB'
	AND a.id = z.beneficiary_id
)
