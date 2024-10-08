SELECT a.bill_number, c.hierarchy_Code, 
a.signed_by, d.user_Name, b.designation, 
a.signed_on,a.pan_number, d.user_Code,
a.cert_sl_no,a.shared_doc_id, a.received_doc_id
FROM ctmis_session_dsc.digital_signature_logs a
JOIN pfmaster.seat_user_alloted b
	ON a.allot_id = b.allot_Id
JOIN pfmaster.hierarchy_setup c
	ON b.seat_Id = c.hierarchy_Id
JOIN pfmaster.user_setup d
	ON b.user_Id = d.user_Id
WHERE
a.bill_id IN 
( 
'18040374',
'18089312',
'18040509'
)
ORDER BY a.bill_id, a.signed_on
LIMIT 0,10