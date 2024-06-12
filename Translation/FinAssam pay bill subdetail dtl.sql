SELECT 
t.token, DATE(t.token_date),  try.hierarchy_Code, '' sub_detail_head, SUM( c.amount) ,'' create_uid, DATE(t.token_date) create_date, 
'' MODIFIED_UID, '' MODIFIED_DATE,
'--------' ,d.code,d.bill_type,d.bill_sub_type , d.component_name,d.component_code , a.total_allowance
from ctmis_master.bill_details_base a 
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T' 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id
join ctmis_master.bill_details_beneficiary b 
	on a.id=b.bill_base
join ctmis_master.bill_details_component c 
	on b.id=c.bill_beneficiary
join ctmis_dataset.bill_component_master d
	on c.component_master= d.code 
	and d.component_type='A'
where  try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'

GROUP BY t.token, DATE(t.token_date),  try.hierarchy_Code,  '' ,   '' , DATE(t.token_date) ,
d.code,d.bill_type,d.bill_sub_type , d.component_name,d.component_code, a.total_allowance
order by a.id DESC