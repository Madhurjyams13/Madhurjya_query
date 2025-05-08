SELECT #dep.hierarchy_Id,
CASE 
    WHEN CAST(mh.head_code AS INTEGER) >= 2000 AND CAST(mh.head_code AS INTEGER) < 4000 THEN 'Revenue'
    WHEN CAST(mh.head_code AS INTEGER) >= 4000 AND CAST(mh.head_code AS INTEGER) < 6000 THEN 'Capital'
    WHEN CAST(mh.head_code AS INTEGER) >= 6000 AND CAST(mh.head_code AS INTEGER) < 8000 THEN 'Loan And Advances'
    WHEN CAST(mh.head_code AS INTEGER) > 8000 THEN 'Public'
    ELSE 'Below Major Head 2000'
END AS exp_type,
case 
	when bd.voucher_id IS NOT NULL 
		then '7. FoC Paid'
	when p.payment_processed_on IS NOT NULL 
		then '6. Bills Uploaded to RBI eKuber'
	when bd.approved_by IS NOT NULL 
		then '5. Bill Approved by Treasury'
	when bd.rejected_by IS NOT NULL 
		then '5. Bill Rejected by Treasury'
	when bd.accepted_on IS NOT NULL 
		then '4. Processing in Treasury'
	when bd.accepted_on IS NULL AND bd.foc_number IS NOT NULL 
		then '3. Bills Submitted to Treasury'
	when cd.ceiling_valid < DATE(NOW())
		then '2. Ceiling Expired'
	ELSE '1. FoC Issued'
END AS STATUS, 
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
dep.hierarchy_Name dep, ofc.hierarchy_Name ofc_name, 
ofc.office_Address ofc_address,
ddo.hierarchy_Code ddo_code, 
cd.ceiling_acc_no foc, date(cl.fin_Approved_On) foc_date, 
cd.ceiling_valid valid,
ROUND((cl.amount*100000),2) amount,
ROUND((cl.amount/100),2) amount_in_cr,
cl.fin_Remarks, cl.issued_Remarks,
DATEDIFF(cd.ceiling_valid,date(NOW())) validity
FROM probityfinancials.ceiling_distributed cd
JOIN probityfinancials.ceiling_request_checklist cl
	ON cd.checklist_Id = cl.id
JOIN probityfinancials.ceiling_distributed_heads ch
	ON cd.id = ch.dis_id
JOIN probityfinancials.heads h
	ON ch.head_id = h.head_id
JOIN pfmaster.hierarchy_setup ddo
	ON cd.office_id = ddo.hierarchy_Id
	AND ddo.category = 'S'
JOIN pfmaster.hierarchy_setup ofc
	ON ddo.parent_hierarchy = ofc.hierarchy_Id
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
LEFT JOIN ctmis_master.bill_details_base bd
	ON cd.ceiling_acc_no = bd.foc_number
	AND bd.rejected_by IS NULL 
LEFT JOIN ctmis_master.payment_bills pb
	ON bd.id = pb.bill_details_base_id
LEFT JOIN ctmis_master.payment_base p
	ON pb.bill_details_base_id = p.id
WHERE
cl.fin_Year='2025-26'
AND cl.fin_Approved_by IS NOT NULL 
AND cl.fin_Approved_on BETWEEN '2025-04-01' AND DATE(NOW()) 
#{% if url_param('deptId') }
#        AND dep.hierarchy_id = {{ url_param('deptId') }}
#    {% endif %} 
 
