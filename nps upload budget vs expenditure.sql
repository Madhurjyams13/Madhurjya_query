SELECT 
#tr.hierarchy_Code "Treasury Code", 
tr.hierarchy_Name "Treasury Name",
bud.bud "Budget Distributed",
ex.ex "Expeniture",
(bud.bud - ex.ex) "Balance",
ROUND(((bud.bud - ex.ex)/bud.bud)*100,0) "Balance %",
ex.avg_ex "Month Avg Expenditure" 
FROM 
(
	SELECT a.ddo_id ddo,
	round(SUM(a.allotted_amount),2) bud
	FROM probityfinancials.budget_distribution_details a
	JOIN probityfinancials.budget_distribution_base c
		ON a.base_id = c.id
	JOIN probityfinancials.heads h
		ON a.head_id = h.head_id
	JOIN pfmaster.hierarchy_setup ddo
		ON a.ddo_id = ddo.hierarchy_Id
		AND ddo.category = 'S'
	WHERE
	a.head_id = 43872
	AND c.approved_on IS NOT NULL
	AND ddo.hierarchy_Code <> 'DIS/AAT/001'
	GROUP BY a.ddo_id
) bud

LEFT JOIN 

(
	SELECT a.ddo_id ddo,
	ROUND(SUM(a.total_allowance)/100000,2) ex,
	ROUND( 
			ROUND(
				SUM(a.total_allowance)/
				(TIMESTAMPDIFF(MONTH, MIN(a.voucher_date), CURDATE()))
				, 2
			)/100000 ,2
		) 		
		AS avg_ex
	FROM ctmis_master.bill_details_base a
	JOIN probityfinancials.heads h
		ON a.head_id = h.head_id
	WHERE
	a.head_id = 43872
	AND date(a.voucher_date) >= '2024-04-01' 
	GROUP BY a.ddo_id
) ex
ON bud.ddo = ex.ddo
JOIN ctmis_dataset.treasury_ddo_mapping d
	ON bud.ddo = d.ddo_id
JOIN pfmaster.hierarchy_setup tr
	ON d.office_id = tr.hierarchy_Id
	AND tr.category = 'T'
ORDER BY 5 
;



SELECT tr.hierarchy_Code, tr.hierarchy_Name,
date(MAX(a.submitted_nsdl_on)), 
DATEDIFF(NOW(),MAX(a.submitted_nsdl_on)) days 
FROM ctmis_master.bills_nps_contribution_base a
JOIN pfmaster.hierarchy_setup tr
	ON a.treasury_id = tr.hierarchy_Id
	AND tr.category = 'T'
GROUP BY tr.hierarchy_Code, tr.hierarchy_Name
