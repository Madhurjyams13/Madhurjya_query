SELECT a.pran_no, a.* 
FROM probityfinancials.eis_data a
WHERE
a.gpf_or_ppan_no IN 
(
'2012423200101771'
);

SELECT b.ppan_no, b.pran_no, b.* 
FROM probityfinancials.nps_base b
WHERE
b.eis_id IN (265922);

SELECT c.pran, c.* 
FROM ctmis_master.bills_nps_deduction c
WHERE
c.ppan IN 
(
'2012423200101771'
)
ORDER BY c.year, c.month;
