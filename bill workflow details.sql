SELECT a.bill_number,a.token_number,date(a.token_date),
b.entry_date, b.processed_on,
d.user_Name ,e.hierarchy_Name,
b.flow_type, b.flow_notes
FROM ctmis_master.bill_details_flow b
JOIN ctmis_master.bill_details_base a
	ON b.bill_base = a.id
JOIN pfmaster.seat_user_alloted c
	ON b.to_seat=c.allot_Id
JOIN pfmaster.user_setup d
	ON c.user_Id=d.user_Id
JOIN pfmaster.hierarchy_setup e
	ON c.seat_Id = e.hierarchy_Id
WHERE a.bill_number='BILL/202425/DISSE055/00074'