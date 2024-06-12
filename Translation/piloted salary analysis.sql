#SELECT m.vd, m.dh, SUM(m.ben) sben, SUM(m.gross) sgross, SUM(m.net) snet FROM 
(
	SELECT CONCAT( substr(monthname(bdb2.voucher_date), 1,3), '/' ,year(bdb2.voucher_date) ) vd, hs.head_code dh, bdb2.bill_number, 
	count(bdb.id) AS ben , bdb2.total_allowance gross, bdb2.total_net_amount net
	FROM ctmis_accounts.ledger_expenditure le 
	JOIN ctmis_master.bill_details_base bdb2 
		ON le.source_reference = bdb2.id 
	JOIN pfmaster.hierarchy_setup try 
		ON le.treasury = try.hierarchy_Id
	JOIN ctmis_master.bill_details_beneficiary bdb 
		ON le.source_reference = bdb.bill_base 
	JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id 
	JOIN probityfinancials.head_setup hs 
		ON h.detailed_head = hs.head_setup_id 
	JOIN pfmaster.hierarchy_setup hs2 
		ON le.treasury = hs2.hierarchy_Id 
	WHERE  date(bdb2.voucher_date) BETWEEN '2023-04-01' AND '2024-01-01'
	AND concat(hs.head_code, bdb2.sub_type) IN ('01SB_SB','02WB_WB','31GA_GA')    #('01SB_SB')#, '0222', '315')
	AND try.hierarchy_Code = 'KKJ'
	AND le.source_category = 'BILLS'
	GROUP BY CONCAT( substr(monthname(bdb2.voucher_date),1,3), '/' ,year(bdb2.voucher_date) ),  hs.head_code, bdb2.bill_number, bdb2.stager_id  
	, bdb2.total_allowance, bdb2.total_net_amount

) m
#GROUP BY m.vd, m.dh