SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS "Department", dep.office_Name "Office Name", 
dep.office_Address "Office Address",
a.emp_First_Name "First Name", 
a.emp_middle_Name "Middle Name", 
a.emp_Last_Name "Last Name",
a.dateofbirth "Date of Birth", 
a.gender "Gender", a.acc_Num "Account No", a.sal_acc_Bank "Bank" ,
a.branch_name "Branch Name", a.ifsc_code "IFSC",
a.removal_remarks "Remarks by DDO", date(a.removed_on) "Removed on",
a.reason_of_death "Reason of Date", a.date_of_demise "Date of Demise",
a.mobile_no "Mobile No", a.email_id "eMail Id"
FROM probityfinancials.eis_data a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_Id = ddo.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep
	ON ddo.parent_hierarchy = dep.hierarchy_Id
JOIN pfmaster.hierarchy_setup dir
	ON dep.parent_hierarchy = dir.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep1
	ON dir.parent_hierarchy = dep1.hierarchy_Id
WHERE
DATE(a.removed_on) >= '2025-03-01'
AND a.removal_reason = 'E'
ORDER BY 1