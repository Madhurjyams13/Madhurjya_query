SELECT 
m.bstatus, COUNT(m.bill_id), SUM(m.amount), SUM(m.ben_count) #uncomment for aggregated figures
#m.* #uncomment for details list
FROM 
(
SELECT 
case 
	when b.voucher_date IS NOT NULL 
		then '9. Bill Paid'
	when pbi.payment_acknowledgement_status IS NOT NULL  
		then CONCAT('8. Bill Payment Status : ', pbi.payment_acknowledgement_status)
	when pb.payment_acknowledgement_status IS NOT NULL  
		then CONCAT('7. Bill Batch Payment Status : ', pb.payment_acknowledgement_status)
	when pb.biz_msg_idr IS NOT NULL 
		then '6. Uploaded to eKuber'
	when b.approved_by IS NOT NULL
		then '5. Bill Approved by the Treasury' 
	when b.accepted_by IS NOT NULL AND b.approved_by IS NULL AND b.rejected_by IS NULL 
		then '4. Bill Processing at the Treasury'	
	when b.source_bill_id IS NOT NULL AND b.accepted_by IS NULL 
		then '3. Bill Submitted'	
	when a.bill_generated = 'Y' AND b.source_bill_id IS NULL 
		then '2. Bill Generated'
	when a.bill_generated = 'N'
		then '1. Bill NOT Generated'
	when b.rejected_by IS NOT NULL
		then 'Bill Rejected by the Treasury' 
	ELSE 'Others' 
END AS bstatus,
a.bill_id,				
a.bill_no, 
b.total_allowance amount,
round(b.total_allowance/1250,0) ben_count
#,a.*,'------', b.*
FROM pfpaybills.paybill_base a
JOIN probityfinancials.heads h
	ON a.head_id = h.head_id
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
LEFT JOIN ctmis_master.bill_details_base b
	ON a.bill_id = b.source_bill_id
LEFT JOIN ctmis_master.payment_bills pbi
	ON b.id = pbi.bill_details_base_id
LEFT JOIN ctmis_master.payment_base pb
	ON pbi.payment_base_id = pb.id
WHERE
ddo.hierarchy_Code like 'DIS/FEB/001%' 
AND DATE(a.created_on) BETWEEN '2024-12-01' AND '2024-12-10' 
AND a.head_id = 68692 
AND a.delete_status = 'N' 
AND a.bill_type = 'GA' 

ORDER BY a.bill_id DESC 
) m
GROUP BY m.bstatus ORDER BY 1 #uncomment for aggregated figures