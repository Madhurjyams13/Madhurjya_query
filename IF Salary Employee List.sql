SELECT 
case 
	when dep1.hierarchy_Name = 'Finassam' 
	then dir.hierarchy_Name
	ELSE dep1.hierarchy_Name 
END AS "Department",
trim(upper(b.beneficiary_name)) "Employee Name", 
e.dateofbirth "Date of Birth",
e.mobile_no "Mobile", e.email_id "e Mail", 
e.appoin_Date "Appointment Date",
e.gender "Gender", b.beneficiary_bank_account "Bank Account Number", 
b.beneficiary_bank_ifsc "IFSC",
case 
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'SBIN' then 'State Bank of India'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'PUNB' then 'Punjab National Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'UBIN' then 'Union Bank of India'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'BKID' then 'Bank of India'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'HDFC' then 'HDFC Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'CNRB' then 'Canara Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'CBIN' then 'Canara Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'UCBA' then 'UCO Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'IBKL' then 'IDBI Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'IDIB' then 'IDBI Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'PSIB' then 'Punjab & Sind Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'IOBA' then 'Indian Overseas Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'BARB' then 'Bank of Baroda'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'UTIB' then 'Axis Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'ICIC' then 'ICICI Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'FDRL' then 'Federal Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'BDBL' then 'Bandhan Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'MAHB' then 'Mashreq Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'SIBL' then 'South Indian Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'YESB' then 'Yes Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'INDB' then 'IndusInd Bank'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'UTBI' then 'United Bank of India'
	when SUBSTR(b.beneficiary_bank_ifsc,1,4) = 'KARB' then 'Karur Vysya Bank'
	ELSE CONCAT('Others - GIS Amount = ' , c.amount)
END AS "Bank",
b.beneficiary_code "Beneficiary Code/ID",
case 
	when c.amount = 400 then 'I'
	when c.amount = 300 then 'II'
	when c.amount = 200 then 'III'
	when c.amount = 100 then 'IV'
	when c.amount = 120 then 'AIS'
	ELSE 'Others'
END AS "Grade",
tr.hierarchy_Code "Treasury Code", tr.hierarchy_Name "Treasury Name",
ddo.hierarchy_Code "DDO Code", dep.office_Name "Office Name", 
dep.office_Address "Office Address",
b.allowance "Gross Salary"
FROM ctmis_master.bill_details_beneficiary b
JOIN ctmis_master.bill_details_base a
	ON b.bill_base = a.id
JOIN ctmis_master.bill_details_component c
	ON b.id = c.bill_beneficiary
	AND a.id = c.bill_base
	AND c.component_master IN ('SB_SB_AGIS','SB_SB_TGIS')
JOIN probityfinancials.eis_data e
	ON b.beneficiary_id = e.id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep
	ON ddo.parent_hierarchy = dep.hierarchy_Id
JOIN pfmaster.hierarchy_setup dir
	ON dep.parent_hierarchy = dir.hierarchy_Id
JOIN pfmaster.hierarchy_setup dep1
	ON dir.parent_hierarchy = dep1.hierarchy_Id
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
WHERE
a.pay_year = 2025
AND a.pay_month = 4
AND a.sub_type = 'SB_SB'
AND a.voucher_id IS NOT NULL
ORDER BY 1,14 
# columns to be converted to text E, I, L