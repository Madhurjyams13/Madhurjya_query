SELECT a.pran_no, a.gpf_or_ppan_no, a.pran_no, a.emp_First_Name, a.emp_Last_Name,
a.acc_Num,
c.*#, '----->', d.*
FROM probityfinancials.eis_data a
LEFT JOIN pfmaster.hierarchy_setup b
	ON a.ddo_Id = b.hierarchy_Id
LEFT JOIN probityfinancials.nps_base c
	ON a.id = c.eis_id
#JOIN pflog.nps_pran_schedules d
#	ON c.id =  d.nps_base_id
WHERE
a.id = 898235
and b.hierarchy_Code = 'NSL/DME/001'

#2018452400300003