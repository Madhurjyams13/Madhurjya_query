select
	ledgerrece0_.receipt_date as col_0_0_,
	receiptbas1_.challan_number as col_1_0_,
	ledgerrece0_.voucher_number as col_2_0_,
	ledgerrece0_.who_deposited as col_3_0_,
	ledgerrece0_.for_whom_deposited as col_4_0_,
	receiptbas1_.particulars as col_5_0_,
	headsetup5_.head_code as col_6_0_,
	headsetup5_.head_name as col_7_0_,
	headsetup6_.head_code as col_8_0_,
	headsetup7_.head_code as col_9_0_,
	substring(headofacco4_.head, 13, 4) as col_10_0_,
	ledgerrece0_.amount as col_11_0_,
	headofacco4_.ga_ssa_status as col_12_0_
from
	ctmis_accounts.ledger_receipts ledgerrece0_
inner join ctmis_egras.receipt_base receiptbas1_ on
	ledgerrece0_.source_reference = receiptbas1_.id
left outer join ctmis_egras.receipt_payer_details payerdetai2_ on
	receiptbas1_.id = payerdetai2_.receipt_base
left outer join ctmis_dataset.bill_component_master billcompon3_ on
	receiptbas1_.source_master_code = billcompon3_.code
inner join probityfinancials.heads headofacco4_ on
	ledgerrece0_.head_of_account = headofacco4_.head_id
inner join probityfinancials.head_setup headsetup5_ on
	headofacco4_.major_head = headsetup5_.head_setup_id
inner join probityfinancials.head_setup headsetup6_ on
	headofacco4_.sub_major_head = headsetup6_.head_setup_id
inner join probityfinancials.head_setup headsetup7_ on
	headofacco4_.minor_head = headsetup7_.head_setup_id
inner join probityfinancials.head_setup headsetup8_ on
	headofacco4_.sub_head = headsetup8_.head_setup_id
inner join pfmaster.hierarchy_setup hierarchys9_ on
	ledgerrece0_.treasury = hierarchys9_.hierarchy_Id
where
	year(ledgerrece0_.receipt_date)= 2005
	and month(ledgerrece0_.receipt_date)= 1
	and (receiptbas1_.transfer_flag is null
		or receiptbas1_.transfer_flag not in ("A", "P"))
	and hierarchys9_.hierarchy_Id = 172
	and headsetup5_.head_code  = '8782'
	and ledgerrece0_.migration_rejection_status ='N'
	and (receiptbas1_.receipt_type is null
		or (receiptbas1_.receipt_type is not null)
			and (receiptbas1_.receipt_type not in ('LF')))
	and (headofacco4_.head_id not in (19890 , 13353))
	and (headsetup8_.head_setup_id not in (2663 , 21316))
order by
	headsetup5_.head_code asc,
	headsetup6_.head_code asc,
	headsetup7_.head_code asc,
	ledgerrece0_.voucher_number asc
LIMIT 10