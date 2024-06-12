SELECT a.id, pb.biz_msg_idr, try.hierarchy_Code, t.token, DATE(t.token_date)
,pbi.net_amount , COUNT(pbd.end_to_end_id) ,pb.payment_processed_on, '' REMARKS, '' MAC_ADDRESS, '' IP_ADDRESS, 'Y' ZIPCREATED
#,'----------' ,pbd.* , '---------------' ,pbi.*
FROM ctmis_master.bill_details_base a 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id	
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T'
JOIN ctmis_master.payment_bills pbi
	ON a.id = pbi.bill_details_base_id
JOIN ctmis_master.payment_base pb
	ON pbi.payment_base_id = pb.id 
JOIN ctmis_master.payment_bill_details pbd 
	ON pbi.id = pbd.payment_bill_id
WHERE
try.hierarchy_Code IN ( 'UDG','BHR' )
AND DATE(a.token_date) >= '2024-01-29'
GROUP BY a.id, pb.biz_msg_idr, try.hierarchy_Code, t.token, DATE(t.token_date)
,pbi.net_amount  ,pb.payment_processed_on, ''  ''  '' , 'Y' 
ORDER BY a.id DESC
#LIMIT 0,20