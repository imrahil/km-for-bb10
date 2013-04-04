SELECT
  upd.id
FROM sync_update_elements AS upd
  LEFT
  JOIN sync_insert_elements AS ins
    ON upd.id = ins.id
WHERE upd.table_name = 'transactions' AND ins.id IS NULL;