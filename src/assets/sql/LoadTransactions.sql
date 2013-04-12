SELECT
  id,
  transactionId,
  userAccountId,
  currencyAmount,
  currencyName,
  amount,
  transactionOn,
  bookedOn,
  description,
  categoryName,
  categoryId,
  tagString,
  direction,
  isWallet
FROM transactions
WHERE userAccountId = :userAccountId
ORDER BY transactionOn DESC, transactionId ASC;
