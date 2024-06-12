SELECT a.id, t.token, DATE(t.token_date), try.hierarchy_Code, 1, '' DDO_NAME,
pb.net_amount 
,'' CHEQUE_MODE , '' PAYMENT_MODE 
,'' CHEQUE_NUMBER,'' CHEQUE_DATE,'' MICR_NUMBER #will be populated later from payment cheque
,'' CREATE_UID, DATE(a.approved_on)
,'' MODIFIED_UID , '' MODIFIED_DATE, 'A', 'Y', 1, 'Y', pb.payment_scheduled_on, pb.token_number, pb.payment_type
#,a.*, '----------' ,pb.*
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
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'
ORDER BY a.id DESC 

