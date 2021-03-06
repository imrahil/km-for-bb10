INSERT INTO accounts
(
  accountId,
  balance,
  bankName,
  bankPluginName,
  currencyBalance,
  currencyName,
  displayName,
  iban,
  ibanChecksum,
  is_default_wallet
)
  VALUES
  (
    :accountId,
    :balance,
    :bankName,
    :bankPluginName,
    :currencyBalance,
    :currencyName,
    :displayName,
    :iban,
    :ibanChecksum,
    :is_default_wallet
  )