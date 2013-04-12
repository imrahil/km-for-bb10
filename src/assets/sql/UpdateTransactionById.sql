UPDATE transactions SET
  currencyAmount = :currencyAmount,
  transactionOn = :transactionOn,
  description = :description,
  currencyName = :currencyName,
  categoryId = :categoryId,
  categoryName = :categoryName
WHERE id = :id;
