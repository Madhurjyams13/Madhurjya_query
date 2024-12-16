SELECT a.pran_no, a.* 
FROM probityfinancials.eis_data a
WHERE
a.gpf_or_ppan_no IN 
(
'2010352700201142'
);

SELECT b.ppan_no, b.pran_no, b.* 
FROM probityfinancials.nps_base b
WHERE
b.eis_id IN (1156069,963741);

SELECT c.pran, c.* 
FROM ctmis_master.bills_nps_deduction c
WHERE
c.ppan IN 
(
'2010352700201142'
)
ORDER BY c.year, c.month;
