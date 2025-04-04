SELECT 
YEAR(b.voucher_date), MONTH(b.voucher_date),
SUM(a.amount)
FROM ctmis_master.bill_details_component a
JOIN ctmis_master.bill_details_base b
	ON a.bill_base = b.id
WHERE
a.component_master IN 
(
'CB_59_DMFT','CB_FV_DMFT','PF_SNA_DMFT','RB_WA_DMFT'
#'CB_59_MDRF','CB_FV_MDRF','PF_SNA_MDRF','RB_WA_MDRF'
)
AND b.approved_by IS NOT NULL 
AND DATE(b.voucher_date) >= '2024-04-01' 
GROUP BY YEAR(b.voucher_date), MONTH(b.voucher_date)
ORDER BY 1,2