SET @search_term = 'NPS';

SELECT 
  concat(a.TABLE_SCHEMA,'.',a.TABLE_NAME) AS "Table",
  a.TABLE_ROWS AS "Rows",
  ROUND((a.DATA_LENGTH + a.INDEX_LENGTH) / 1024 / 1024, 2) AS "Size",
  a.UPDATE_TIME AS "Last Update"
FROM 
  information_schema.TABLES a
WHERE
  a.TABLE_SCHEMA NOT IN 
    ('information_schema','mysql','performance_schema','sys')
  AND a.TABLE_ROWS > 0 
AND ( upper(a.TABLE_NAME) LIKE CONCAT('%', @search_term, '%') OR upper(a.TABLE_SCHEMA) LIKE CONCAT('%', @search_term, '%') )
ORDER BY a.TABLE_SCHEMA, a.TABLE_NAME;