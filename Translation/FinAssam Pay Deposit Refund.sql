SELECT rb.id, t.token, DATE(t.token_date), rb.voucher_number, date(rb.challan_deposit_date), try.hierarchy_Code, rb.total_receipt, 
'' CREATE_UID, date(ldr.entry_date), '' MODIFIED_UID, '' MODIFIED_DATE,
case when ld.receipt_type = 'GT' then 'TD' ELSE ld.receipt_type END AS RECEIPT_TYPE , ldr.balance_amount, ldr.deduction_amount, ld.current_flag, c.token, DATE(c.challan_date),
tryf.hierarchy_Code
#'------',ldr.*, '------', ld.*
#, '---', a.* 
FROM ctmis_accounts.ledger_deposit_refund ldr
JOIN  ctmis_accounts.ledger_deposit ld
	ON ld.id = ldr.ledger_deposit	
JOIN ctmis_master.bill_details_base a
	ON ldr.source_reference = a.id 
	AND ldr.source_category = 'BILLS'
JOIN pfmaster.hierarchy_setup try 
	ON a.treasury_id = try.hierarchy_Id
	AND try.category = 'T' 
JOIN ctmis_master.token_master t
	ON a.token_id = t.id
JOIN ctmis_egras.receipt_base rb
	ON ld.source_reference = rb.id
JOIN pfmaster.hierarchy_setup tryf 
	ON rb.treasury_id = tryf.hierarchy_Id
	AND try.category = 'T'
JOIN ctmis_master.challan_master c
	ON rb.challan_id = c.id
WHERE
try.hierarchy_Code = 'KKJ'
AND DATE(a.token_date) >= '2023-11-28'
#AND ldr.gross_amount <> ldr.deduction_amount
#AND rb.id = 85301307
#AND ld.receipt_type = 'GT'
ORDER BY ldr.source_reference DESC #LIMIT 0,50