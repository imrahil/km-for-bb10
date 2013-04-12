SELECT 'delete' as 'table_name', count(rowid) as 'count' FROM sync_delete_elements
UNION ALL 
SELECT 'insert' as 'table_name', count(rowid) as 'count' FROM sync_insert_elements
UNION ALL 
SELECT 'update' as 'table_name', count(rowid) as 'count' FROM sync_update_elements;