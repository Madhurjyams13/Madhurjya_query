SELECT bdb.pay_month pmon, bdb.pay_year, 
  COUNT(*) , SUM(bdb2.allowance)/10000000
FROM
ctmis_master.payment_base x
join ctmis_master.payment_bills pb on x.id=pb.payment_base_id
join ctmis_master.bill_details_base bdb on pb.bill_details_base_id=bdb.id
join ctmis_master.bill_details_beneficiary bdb2 on bdb2.bill_base=bdb.id
join pfmaster.hierarchy_setup hs on bdb.treasury_id=hs.hierarchy_Id
JOIN  pfmaster.hierarchy_setup hs1 on bdb.ddo_id =hs1.hierarchy_Id
join pfmaster.seat_user_alloted sua on hs1.hierarchy_Id=sua.seat_Id
join pfmaster.user_setup us on us.user_Id=sua.user_Id  
join pfmaster.hierarchy_setup hs2 on hs1.parent_hierarchy=hs2.hierarchy_Id  
WHERE #bdb.financial_year='2023-24' 
date(x.payment_processed_on) BETWEEN DATE('2024-01-01') AND DATE('2024-07-30')
and bdb.type='SB' 
AND bdb.sub_type='SB_SB' 
and sua.active_Status='Y'
AND   
#and bdb.pay_month>=4
and bdb.pay_year=2024

 group by bdb.pay_month ,bdb.pay_year;
 
 
 
 SELECT m.component_name, SUM(m.emp_allowance),
ROUND(SUM(m.emp_allowance)/10000000,2) 
FROM 
(

SELECT CONCAT(a.pay_month,'')salary_month , CONCAT(a.pay_year,'')pyr, 
SUM(com.amount) emp_allowance,
cm.component_code, cm.component_name

#cm.component_code, cm.component_name, com.amount
#cm., ben., '----', com.* 
FROM ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id 
JOIN pfmaster.hierarchy_setup try
	ON a.treasury_id = try.hierarchy_Id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
LEFT JOIN ctmis_master.bill_details_beneficiary ben
	ON a.id = ben.bill_base
JOIN ctmis_master.bill_details_component com
	ON a.id = com.bill_base
	AND ben.id = com.bill_beneficiary 
JOIN ctmis_dataset.bill_component_master cm
	ON com.component_master = cm.code
WHERE
a.pay_year = 2024
and a.pay_month = 4
#AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND a.sub_type = 'SB_SB'
AND cm.component_type = 'A'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'

GROUP BY CONCAT(a.pay_month,'') , CONCAT(a.pay_year,'')
, cm.component_code, cm.component_name


UNION ALL 

SELECT CONCAT(a.pay_month,'')salary_month , CONCAT(a.pay_year,'')pyr, 
SUM(com.amount) emp_allowance,
cm.component_code, cm.component_name

#cm.component_code, cm.component_name, com.amount
#cm., ben., '----', com.* 
FROM ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id 
JOIN pfmaster.hierarchy_setup try
	ON a.treasury_id = try.hierarchy_Id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_master.bill_details_component com
	ON a.id = com.bill_base
	AND com.bill_beneficiary IS NULL  
JOIN ctmis_dataset.bill_component_master cm
	ON com.component_master = cm.code
WHERE
a.pay_year = 2024
and a.pay_month = 4
#AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND a.sub_type = 'SB_SB'
AND cm.component_type = 'A'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'
#AND cm.component_code IN ('TGIS', 'TPT')
#16961213 bill details base id
#732731 stager id
#BILL/202425/DMJGAD001/00141(R1) bill number
GROUP BY CONCAT(a.pay_month,'') , CONCAT(a.pay_year,'')
, cm.component_code, cm.component_name

) m

GROUP BY m.component_name 
ORDER BY 1;

SELECT m.bill_number FROM 
(
SELECT 
a.bill_number, a.total_allowance, com.*
FROM ctmis_master.bill_details_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id 
JOIN pfmaster.hierarchy_setup try
	ON a.treasury_id = try.hierarchy_Id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_master.bill_details_component com
	ON a.id = com.bill_base
	AND com.bill_beneficiary IS NULL  
JOIN ctmis_dataset.bill_component_master cm
	ON com.component_master = cm.code
WHERE
a.pay_year = 2024
and a.pay_month = 2
#AND ddo.hierarchy_Code = 'DIS/AAT/001'
AND a.sub_type = 'SB_SB'
AND cm.component_type = 'A'
AND a.approved_by IS NOT NULL 
AND SUBSTR(h.head,22,2) = '01'
) m
GROUP BY m.bill_number
HAVING SUM(m.amount) <> sum(m.total_allowance)/COUNT(*)

 