SELECT c.name bill_type, d.pan_No, d.gpf_or_ppan_no,
a.beneficiary_name, b.bill_number, b.bill_date, 
b.total_allowance bill_gross, 
(b.total_allowance - b.total_deduction ) bill_net, 
b.voucher_number,date(b.voucher_date) voucher_date
FROM probityfinancials.eis_data d
JOIN ctmis_master.bill_details_beneficiary a
	ON d.id = a.beneficiary_id 
JOIN ctmis_master.bill_details_base b
	ON a.bill_base = b.id
JOIN ctmis_dataset.bill_sub_type_master c
	ON b.sub_type = c.code
WHERE
a.beneficiary_type = 'E'
AND 
( 
	#d.pan_No = 'BEBPS2377J' 
	##### Enter PAN NUMBER in the above line --
	#OR 
	#d.gpf_or_ppan_no LIKE '%20409%' 
	#### IF not Data Found in PPAN - remove the # in the previous line and 
	#Use GPF Number inside like- e.g. for MED33178- use LIKE '%MED%33178%'
	d.id = 690756
)
AND b.approved_by IS NOT NULL 
ORDER BY b.voucher_date DESC 