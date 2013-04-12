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
  JOIN sync_insert_elements AS s
    ON t.id = s.id
WHERE s.table_name = 'transactions';
