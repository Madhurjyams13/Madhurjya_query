SELECT h.source_eis_bank_ifsc, COUNT(*)
FROM ctmis_staging.staging_bill_details_base a
JOIN pfmaster.hierarchy_setup ddo
	ON a.ddo_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN ctmis_staging.staging_bill_details_grants_in_aid h 
	ON a.id = h.bill_base
WHERE
ddo.hierarchy_Code = 'DIS/FEB/001'
AND date(a.received_on) >= '2024-10-01'
AND a.head_of_account_id = 68692
/*AND h.source_eis_bank_ifsc IN 
(
'SBIN0000201',
'SBIN0006207',
'SBIN0006510',
'SBIN0007130',
'SBIN0010076',
'SBIN0010390',
'SBIN0010550',
'SBIN0010678',
'SBIN0010716',
'SBIN0010752',
'SBIN0010756',
'SBIN0011013',
'SBIN0011083',
'SBIN0011479',
'SBIN0011636',
'SBIN0013215',
'SBIN0013690',
'SBIN0013951',
'SBIN0013954',
'SBIN0013990',
'SBIN0014021',
'SBIN0014478',
'SBIN0014839',
'SBIN0015433',
'SBIN0015607',
'SBIN0016078',
'SBIN0016334',
'SBIN0017258',
'SBIN0018533',
'SBIN0018750',
'SBIN0018809',
'SBIN0020091',
'SBIN0020852',
'SBIN0021179',
'SBIN0031001',
'SBIN0032609',
'SBIN0040698',
'SBIN0050346',
'SBIN0050738',
'SBIN0060122',
'SBIN0063225',
'SBIN0063226',
'SBIN0063237',
'SBIN0063241',
'SBIN0063253',
'SBIN0063264',
'SBIN0063555',
'UBIN0571237',
'UTBI0RRBAGB'
)*/
GROUP BY h.source_eis_bank_ifsc