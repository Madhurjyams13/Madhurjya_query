#EXPLAIN  
SELECT
e.emp_First_Name "First Name" , 
e.emp_middle_Name "Middle Name", 
e.emp_Last_Name "Last Name",
e.mobile_no "Mobile No", p.post_Name "Designation", 
concat(ofc.hierarchy_Name, '-' ,ofc.office_Address) "Office Name & Address",
e.gender "Gender",
TIMESTAMPDIFF(YEAR,e.dateofbirth,NOW()) "Age",
m.bp "Basic Pay"
#,m.* 
FROM 
(
	SELECT 
	c.beneficiary_id, b.ddo_id, (c.allowance-c.deduction), SUM(a.amount) bp
	FROM 
	ctmis_master.bill_details_base b
	JOIN ctmis_master.bill_details_beneficiary c
		ON b.id = c.bill_base
		AND c.beneficiary_type = 'E'
	JOIN ctmis_master.bill_details_component a
		ON b.id = a.bill_base
		AND c.id = a.bill_beneficiary
	JOIN pfmaster.hierarchy_setup tr
		ON b.treasury_id = tr.hierarchy_Id
		AND tr.category = 'T'
	WHERE
	tr.hierarchy_Code = 'SNP'
	#b.treasury_id = 188
	AND b.approved_by IS NOT NULL
	AND a.component_master IN ('SB_SB_PAY','SB_SB_GP') 
	AND b.sub_type = 'SB_SB'
	AND b.pay_year = 2025
	AND b.pay_month = 1
	GROUP BY c.beneficiary_id, b.ddo_id, (c.allowance-c.deduction)
) m
JOIN probityfinancials.eis_data e
	ON m.beneficiary_id = e.id
JOIN pfmaster.hierarchy_setup ddo
	ON m.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN pfmaster.hierarchy_setup ofc  
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
JOIN probityfinancials.post_setup p
	ON e.post_Id = p.post_Id