SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS "Department",  
tr.hierarchy_Code "Treasury Code",
tr.hierarchy_Name "Treasury Name",
ddo.hierarchy_Code "DDO Code",
dep.office_Name "Office Name",
dep.office_Address "Office Address",
a.emp_First_Name "First Name", 
a.emp_middle_Name "Middle Name", 
a.emp_Last_Name "Last Name",
a.dateofbirth "Date of Birth", 
a.gender "Gender", a.acc_Num "Account No", a.sal_acc_Bank "Bank" ,
a.branch_name "Branch Name", a.ifsc_code "IFSC",
a.removal_remarks "Remarks by DDO", date(a.removed_on) "Removed on",
a.reason_of_death "Reason of Date", a.date_of_demise "Date of Demise",
a.mobile_no "Mobile No", a.email_id "eMail Id",
concat(YEAR(a.removed_on),'/',lpad(MONTH(a.removed_on),2,0)) 
"Removed Month",
concat(YEAR(a.date_of_demise),'/',lpad(MONTH(a.date_of_demise),2,0)) 
"Deceased Month"
FROM probityfinancials.eis_data a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_Id = ddo.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep
	ON ddo.parent_hierarchy = dep.hierarchy_Id
JOIN pfmaster.hierarchy_setup dir
	ON dep.parent_hierarchy = dir.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep1
	ON dir.parent_hierarchy = dep1.hierarchy_Id
JOIN probityfinancials.ddo_setup ds
	ON a.ddo_Id = ds.ddo_id
JOIN pfmaster.hierarchy_setup tr
	ON ds.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
WHERE
DATE(a.removed_on) >= '2025-01-01'
AND a.removal_reason = 'E'
AND 
(
	a.removal_remarks NOT LIKE '%2024%'
	AND 
	a.removal_remarks NOT LIKE '%2023%'
	AND 
	a.removal_remarks NOT LIKE '%2022%'
	AND 
	a.removal_remarks NOT LIKE '%2021%'
) # For This Year
/*(
	a.removal_remarks LIKE '%2024%'
	OR 
	a.removal_remarks LIKE '%2023%'
	OR 
	a.removal_remarks LIKE '%2022%'
	OR 
	a.removal_remarks LIKE '%2021%'
)*/ # For Previous Year

ORDER BY 22,3