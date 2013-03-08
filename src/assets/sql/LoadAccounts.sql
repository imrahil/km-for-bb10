SELECT
  id,
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
FROM accounts
WHERE bankPluginName != "Wallets";
