SELECT a.TABLE_SCHEMA, a.TABLE_NAME,
a.TABLE_ROWS, DATE(a.CREATE_TIME)
#a.TABLE_NAME
FROM information_schema.tables a 
WHERE
a.TABLE_SCHEMA NOT IN ('information_schema','sys','ctmis_direct_migration','mysql')
AND a.TABLE_NAME NOT IN (
    SELECT TABLE_NAME
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE REFERENCED_TABLE_NAME IS NOT NULL
)
ORDER BY 1, 3
;