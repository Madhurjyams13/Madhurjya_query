SELECT m.dep, 
SUM(m.incumbent_count), SUM(m.total_allowance), SUM(m.gp), SUM(m.pay), SUM(m.other)
FROM 
(
	SELECT st.incumbent_count, h.head,
	dep.hierarchy_Name dep, 
	bd.bill_number, 
	bd.total_allowance, bd.id,
	SUM( case when c.component_master = 'SB_SB_GP' then c.amount END) AS gp, 
	SUM( case when c.component_master = 'SB_SB_PAY' then c.amount END) AS pay,
	SUM( case when c.component_master NOT IN ('SB_SB_PAY','SB_SB_GP') then c.amount END) AS other
	#le.*, '--------', bd.* 
	FROM ctmis_accounts.ledger_expenditure le
	JOIN ctmis_master.bill_details_base bd 
		ON le.source_reference = bd.id
		AND le.source_category = 'BILLS'
	JOIN probityfinancials.heads h 
		ON le.head_of_account = h.head_id
	JOIN probityfinancials.head_setup dh 
		ON h.detailed_head = dh.head_setup_id
	JOIN ctmis_staging.staging_bill_details_base st
		ON bd.stager_id = st.id
	JOIN pfmaster.hierarchy_setup dep 
		ON bd.department_id = dep.hierarchy_Id
		AND dep.category = 'D'
	JOIN ctmis_master.bill_details_component c 
		ON bd.id=c.bill_base
	JOIN ctmis_dataset.bill_component_master d
		on c.component_master= d.code 
		and d.component_type='A'
	WHERE
	date(bd.token_date) BETWEEN '2024-04-01' AND '2024-05-30'
	AND le.financial_year = '2024-25'
	AND le.source_category = 'BILLS'
	AND bd.pay_month = 3
	AND bd.pay_year = 2024
	AND dh.head_code = '01'
	AND bd.sub_type = 'SB_SB'
	#AND bd.bill_number LIKE 'BILL/202425/DISAAT001%'
	
	GROUP BY 
	st.incumbent_count, h.head, 
	dep.hierarchy_Name , bd.bill_number, 
	bd.total_allowance, bd.id
)
m
GROUP BY m.dep