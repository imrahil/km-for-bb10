SELECT
  t.id,
  t.transactionId,
  t.userAccountId,
  t.currencyAmount,
  t.currencyName,
  t.amount,
  t.transactionOn,
  t.bookedOn,
  t.description,
  t.categoryName,
  t.categoryId,
  t.tagString,
  t.direction,
  t.isWallet
FROM transactions AS t
  LEFT JOIN sync_update_elements AS upd
    ON t.id = upd.id
  LEFT JOIN sync_insert_elements AS ins
    ON upd.id = ins.id
WHERE upd.table_name = 'transactions' AND ins.id IS NULL;