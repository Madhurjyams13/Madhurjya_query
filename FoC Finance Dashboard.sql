SELECT m.fin_year, SUM(m.amount_in_cr) FROM 
(
	SELECT 
	CASE 
	    WHEN CAST(mh.head_code AS INTEGER) >= 2000 AND CAST(mh.head_code AS INTEGER) < 4000 THEN 'Revenue'
	    WHEN CAST(mh.head_code AS INTEGER) >= 4000 AND CAST(mh.head_code AS INTEGER) < 6000 THEN 'Capital'
	    WHEN CAST(mh.head_code AS INTEGER) >= 6000 AND CAST(mh.head_code AS INTEGER) < 8000 THEN 'Loan And Advances'
	    WHEN CAST(mh.head_code AS INTEGER) > 8000 THEN 'Public'
	    ELSE 'Below Major Head 2000'
	END AS exp_type,
	h.head, 
	case 
		when h.plan_status_migration IS NOT NULL  
			then h.plan_status_migration
		when pc.abbreviation IS NOT NULL 
			then pc.abbreviation
		ELSE 'EE'
	END AS scheme, h.ga_ssa_status area_code, h.voted_charged_status vc,
	concat(mh.head_code, '-' ,mh.head_name) major,
	concat(dh.head_code, '-' ,dh.head_name) detail,
	dep.hierarchy_Code dep_code, 
	dep.hierarchy_Name dep,
	cd.fin_year, cd.ceiling_acc_no foc, date(cl.fin_Approved_On) foc_date,
	MONTH(cl.fin_Approved_On) mon, 
	cd.ceiling_valid valid,
	ROUND((cl.amount*100000),2) amount,
	ROUND((cl.amount/100),2) amount_in_cr
	FROM probityfinancials.ceiling_distributed cd
	JOIN probityfinancials.ceiling_request_checklist cl
		ON cd.checklist_Id = cl.id
	JOIN probityfinancials.ceiling_distributed_heads ch
		ON cd.id = ch.dis_id
	JOIN probityfinancials.heads h
		ON ch.head_id = h.head_id
	JOIN pfmaster.hierarchy_setup dep
		ON cl.office = dep.hierarchy_Id
	LEFT JOIN probityfinancials.plan_category_head_mapping pchm
		ON h.head_id = pchm.head_id
	LEFT JOIN probityfinancials.plan_category pc 
		ON pchm.pc_id = pc.pc_id
	JOIN probityfinancials.head_setup mh
		ON h.major_head = mh.head_setup_id
	JOIN probityfinancials.head_setup dh
		ON h.detailed_head = dh.head_setup_id
	WHERE
	cl.fin_Approved_by IS NOT NULL 
	AND cl.fin_Approved_on BETWEEN '2022-04-01' AND DATE(NOW()) 
) m
GROUP BY m.fin_year